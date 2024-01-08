import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:recase/recase.dart';
import 'package:shelf_routing_generator/src/route_group_handler.dart';
import 'package:shelf_routing_generator/src/route_handler.dart';
import 'package:shelf_routing_generator/src/routers_groups_file_schema.dart';
import 'package:shelf_routing_generator/src/utils.dart';
import 'package:source_gen/source_gen.dart';

Builder runRoutersBuilder(BuilderOptions options) {
  return SharedPartBuilder(
    const [RouterGenerator()],
    'router',
    additionalOutputExtensions: const [RoutersGroupsFileSchema.extension],
  );
}

class RouterGenerator extends Generator {
  const RouterGenerator();

  String? _findParserMethod(DartType type) {
    if (type is! InterfaceType) return null;

    final parserMethod = type.getMethod('parse');
    if (parserMethod == null) return null;

    if (!TypeChecker.fromStatic(type).isAssignableFromType(parserMethod.returnType)) return null;

    final firstParameter = parserMethod.parameters.firstOrNull;
    if (firstParameter == null || firstParameter.isNamed) return null;

    if (!firstParameter.type.isDartCoreString) return null;
    if (parserMethod.parameters.skip(1).any((e) => e.isRequired)) return null;

    return '${type.element.name}.${parserMethod.name}';
  }

  String? _codeParser(DartType type) {
    if (type.isDartCoreBool) return 'bool.parse';
    if (type.isDartCoreInt) return 'int.parse';
    if (type.isDartCoreDouble) return 'double.parse';
    if (type.isDartCoreNum) return 'num.parse';
    if (type.isDartCoreString) return null;
    final parser = _findParserMethod(type);
    if (parser != null) return parser;
    throw UnsupportedError('the var $type has not supported $type type.');
  }

  String _codeListParser(DartType type) {
    if (type.isDartCoreList) {
      var parserCode = _codeParser((type as InterfaceType).typeArguments.single);
      if (parserCode != null) parserCode = '.map($parserCode).toList()';
      return '(vls) => vls${parserCode ?? ''}';
    }
    var parserCode = _codeParser(type);
    parserCode = parserCode != null ? '$parserCode(vls.single)' : 'vls.single';
    if (type.isNullable) {
      return '(vls) => vls.isNotEmpty ? $parserCode : null';
    } else {
      return '(vls) => $parserCode';
    }
  }

  String _codeAddRoute(RouteGroupHandler group, RouteHandler _) {
    final RouteHandler(
      method: verb,
      path: route,
      :element,
      :hasRequest,
      :pathParameters,
      :bodyParameter,
      :headers,
      :queryParameters,
      :returns,
    ) = _;

    final routePath = '${group.id != null ? ' ' : (group.prefix ?? ' ')}$route';

    final routeParams = [
      'Request request',
      ...pathParameters.map((e) => 'String ${e.name}'),
    ].join(', ');

    final headersCode = headers.map((e) => '\n\$ensureHasHeader(request, \'${e.name}\');').join();

    final methodParams = [
      if (hasRequest) 'request',
      ...pathParameters.map((e) {
        final parserCode = _codeParser(e.type);
        return parserCode != null ? '$parserCode(${e.name})' : e.name;
      }),
      if (bodyParameter != null)
        'await request.readAs(${bodyParameter.type.getDisplayString(withNullability: false)}.fromJson)',
      // if (headerParameters.isNotEmpty)
      //   ...headerParameters.map((e) {
      //     final key = e.name.paramCase;
      //     return "${e.name}: \$parseHeaders(request, '$key', ${_codeListParser(e.type)})";
      //   }),
      if (queryParameters.isNotEmpty)
        ...queryParameters.map((e) {
          final key = e.name.paramCase;
          return "${e.name}: \$parseQueryParameters(request, '$key', ${_codeListParser(e.type)})";
        }),
    ].expand((e) sync* {
      yield e;
      yield ',\n';
    }).join();

    var methodInvocation = '';
    if (element.returnType.isDartAsyncFutureOr || element.returnType.isDartAsyncFuture) {
      methodInvocation += 'await ';
    }
    methodInvocation += '\$.${element.name}($methodParams)';

    final responseCode = switch (returns) {
      RouteReturnsType.response => '''
    return $methodInvocation;''',
      RouteReturnsType.json => '''
    final \$data = $methodInvocation;
    return JsonResponse.ok(\$data);''',
      RouteReturnsType.nothing => '''
    $methodInvocation;
    return JsonResponse.ok(null);''',
    };

    return '''
  ..add('$verb', r'$routePath', ($routeParams) async {$headersCode
    final \$ = request.get<${group.element.name}>();
    $responseCode
  })''';
  }

  @override
  Future<String?> generate(LibraryReader library, BuildStep buildStep) async {
    final groups = library.classes.map(RouteGroupHandler.from).nonNulls.toList();
    if (groups.isEmpty) return null;

    // Generate routing

    final routingSchema = RoutersGroupsFileSchema(
      library: library.element.identifier,
      groups: groups.expand<RoutesGroupSchema>((group) sync* {
        final groupId = group.id;
        if (groupId == null) return;

        final class$ = group.element;
        final method = class$.fields.singleWhereOrNull((e) {
          return e.isStatic && isHandlerAssignableFromType(e.type);
        });
        if (method == null) {
          throw InvalidGenerationSource(
            'Missing static router field.',
            todo: 'Router get router => _\$${class$.name}Router',
            element: group.element,
          );
        }
        yield RoutesGroupSchema(
          id: groupId,
          prefix: group.prefix ?? '/',
          code: '${class$.name}.${method.name}',
        );
      }).toList(),
    );
    if (routingSchema.groups.isNotEmpty) {
      final routingAsset = buildStep.allowedOutputs.skip(1).first;
      await buildStep.writeAsString(routingAsset, jsonEncode(routingSchema));
    }

    // Generate router

    return groups.map((_) {
      final RouteGroupHandler(:element, :routes) = _;
      final routesCode = routes.map((route) => _codeAddRoute(_, route)).join();
      return '''
Router get _${codePublicVarName('${element.name}Router')} => Router()\n
  $routesCode;''';
    }).join('\n');
  }
}
