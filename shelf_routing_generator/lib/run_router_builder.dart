import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:recase/recase.dart';
import 'package:shelf_routing_generator/src/route_group_handler.dart';
import 'package:shelf_routing_generator/src/route_handler.dart';
import 'package:shelf_routing_generator/src/routers_schema.dart';
import 'package:shelf_routing_generator/src/utils.dart';
import 'package:source_gen/source_gen.dart';

Builder runRouterBuilder(BuilderOptions options) {
  return SharedPartBuilder(
    const [RouterGenerator()],
    'router',
    additionalOutputExtensions: ['.routers.json'],
  );
}

class RouterGenerator extends Generator {
  const RouterGenerator();

  // String codeDeserialization(ParameterElement element, String varName) {
  //   final type = element.type;
  //   // if (type.isDartCoreList) {
  //   //   final argType = (type as InterfaceType).typeArguments.single;
  //   //   final parser = _codePrimitiveParser(argType);
  //   //
  //   //   if (argType.isDartCoreString) return varName;
  //   //
  //   //   return parser != null ? parser;
  //   // }
  //
  //   if (element.type.nullabilitySuffix == NullabilitySuffix.question || element.hasDefaultValue) {
  //     final defaultValue = element.defaultValueCode ?? 'null';
  //     return '$varName != null ? ${_codePrimitiveParser(type, varName)} : $defaultValue';
  //   }
  //   return _codePrimitiveParser(type, '$varName!');
  // }
  //
  // String _codePrimitiveParser(DartType type, String varName) {
  //   if (type.isDartCoreBool) return 'bool.parse($varName)';
  //   if (type.isDartCoreInt) return 'int.parse($varName)';
  //   if (type.isDartCoreDouble) return 'double.parse($varName)';
  //   if (type.isDartCoreNum) return 'num.parse($varName)';
  //   if (type.isDartCoreString) return varName;
  //   throw UnsupportedError('the var $type has not supported $type type.');
  // }

  String? _findParserMethod(DartType type) {
    print('1');
    if (type is! InterfaceType) return null;
    print('2');
    final parserMethod = type.getMethod('parse');
    if (parserMethod == null) return null;
    print('3');
    if (!TypeChecker.fromStatic(type).isAssignableFromType(parserMethod.returnType)) return null;
    print('4');
    final firstParameter = parserMethod.parameters.firstOrNull;
    if (firstParameter == null || firstParameter.isNamed) return null;
    print('5');
    if (!firstParameter.type.isDartCoreString) return null;
    print('6');
    if (parserMethod.parameters.skip(1).any((e) => e.isRequired)) return null;
    print('7');
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
      :headerParameters,
      :queryParameters,
      :returns,
    ) = _;

    var code = '';

    if (bodyParameter != null) {
      final typeName = bodyParameter.type.getDisplayString(withNullability: false);
      code = 'final ${bodyParameter.name} = await request.readAs($typeName.fromJson);';
    }

    final methodParams = [
      if (hasRequest) 'request',
      ...pathParameters.map((e) {
        final parserCode = _codeParser(e.type);
        return parserCode != null ? '$parserCode(${e.name})' : e.name;
      }),
      if (bodyParameter != null) bodyParameter.name,
      if (headerParameters.isNotEmpty)
        ...headerParameters.map((e) {
          final key = e.name.paramCase;
          return "${e.name}: \$parseHeaders(request, '$key', ${_codeListParser(e.type)})";
        }),
      if (queryParameters.isNotEmpty)
        ...queryParameters.map((e) {
          final key = e.name.paramCase;
          return "${e.name}: \$parseQueryParameters(request, '$key', ${_codeListParser(e.type)})";
        }),
    ].expand((e) sync* {
      yield e;
      yield ',\n';
    }).join();
    final methodInvocation = 'await \$.${element.name}($methodParams)';

    code += switch (returns) {
      RouteReturnsType.response => '''
    return $methodInvocation;''',
      RouteReturnsType.json => '''
    final \$data = $methodInvocation;
    return JsonResponse.ok(\$data);''',
      RouteReturnsType.nothing => '''
    $methodInvocation;
    return JsonResponse.ok(null);''',
    };

    final routeParams = [
      'Request request',
      ...pathParameters.map((e) => 'String ${e.name}'),
    ].join(', ');
    return '''
      ..add('$verb', r'${group.prefix ?? ''}$route', ($routeParams) async {
        final \$ = request.get<${group.element.name}>();
        $code
      })''';
  }

  Future<String?> _generate(LibraryReader library, BuildStep buildStep) async {
    final groups = library.classes.map(RouteGroupHandler.from).nonNulls.toList();
    if (groups.isEmpty) return null;

    // Generate routing

    final routingSchema = RoutersSchema(
      library: library.element.identifier,
      handlers: Map.fromEntries(groups.map((group) {
        final class$ = group.element;
        final method = class$.fields.singleWhereOrNull((e) {
          return e.isStatic && isHandlerAssignableFromType(e.type);
        });
        if (method == null) {
          throw InvalidCodeException.from(
              class$, 'add "Router get router => _\$${class$.name}" code.');
        }
        return MapEntry(group.prefix ?? '/', '${class$.name}.${method.name}');
      })),
    );

    final routingAsset =
        buildStep.allowedOutputs.firstWhere((e) => e.pathSegments.last.endsWith('.routers.json'));
    await buildStep.writeAsString(routingAsset, jsonEncode(routingSchema));

    // Generate router

    return groups.map((_) {
      final RouteGroupHandler(:element, :routes) = _;
      final routesCode = routes.map((route) => _codeAddRoute(_, route)).join();
      return '''
Router get _\$${element.name}Router => Router()\n
  $routesCode;''';
    }).join('\n');
  }

  @override
  Future<String?> generate(LibraryReader library, BuildStep buildStep) async {
    try {
      return await _generate(library, buildStep);
    } on InvalidCodeException catch (exception) {
      log.severe('$exception');
      return null;
    }
  }
}
