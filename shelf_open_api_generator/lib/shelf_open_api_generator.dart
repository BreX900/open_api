import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:open_api_specification/open_api.dart';
import 'package:shelf_open_api/shelf_open_api.dart';
import 'package:shelf_open_api/shelf_routing.dart';
import 'package:shelf_open_api_generator/src/config.dart';
import 'package:shelf_open_api_generator/src/handlers/route_handler.dart';
import 'package:shelf_open_api_generator/src/handlers/routes_handler.dart';
import 'package:shelf_open_api_generator/src/schemas_registry.dart';
import 'package:shelf_open_api_generator/src/utils/annotations_utils.dart';
import 'package:shelf_open_api_generator/src/utils/utils.dart';
import 'package:shelf_open_api_generator/src/utils/yaml_encoder.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:source_gen/source_gen.dart';
import 'package:stream_transform/stream_transform.dart';

Builder buildOpenApi(BuilderOptions options) {
  final rawConfig = Utils.optionYamlToBuilder(options.config);
  final config = Config.fromJson(rawConfig);

  return OpenApiBuilder(
    buildExtensions: {
      '\$package\$': ['public/open_api.yaml']
    },
    config: config,
  );
}

// https://github.com/dart-lang/build/blob/master/docs/writing_an_aggregate_builder.md
class OpenApiBuilder implements Builder {
  // static final _openApiType = TypeChecker.fromRuntime(OpenApiConfig);
  static final _routesType = TypeChecker.fromRuntime(Routes);
  static final _routeType = TypeChecker.fromRuntime(Route);
  static final _openApiRouteType = TypeChecker.fromRuntime(OpenApiRoute);

  @override
  final Map<String, List<String>> buildExtensions;
  final Config config;

  OpenApiBuilder({
    required this.buildExtensions,
    required this.config,
  });

  /// Find members of a class annotated with [shelf_router.Route].
  List<ExecutableElement> getAnnotatedElementsOrderBySourceOffset(ClassElement cls) =>
      <ExecutableElement>[
        ...cls.methods.where(_routeType.hasAnnotationOfExact),
        ...cls.accessors.where(_routeType.hasAnnotationOfExact)
      ]..sort((a, b) => (a.nameOffset).compareTo(b.nameOffset));

  Stream<LibraryElement> _findLibraryWithRoute(BuildStep buildStep) {
    return buildStep.findAssets(Glob(config.includeRoutesIn)).concurrentAsyncExpand((asset) async* {
      if (!await buildStep.resolver.isLibrary(asset)) return;
      yield await buildStep.resolver.libraryFor(asset, allowSyntaxErrors: true);
    });
  }

  String _generate(Iterable<LibraryElement> libraries) {
    final schemasRegistry = SchemasRegistry();

    final elements = libraries.expand((e) {
      return LibraryReader(e).classes.expand(getAnnotatedElementsOrderBySourceOffset);
    }).toList();

    final routes = elements.expand((executableElement) {
      final routesAnnotation =
          ConstantReader(_routesType.firstAnnotationOf(executableElement.enclosingElement));
      final openApiAnnotation =
          ConstantReader(_openApiRouteType.firstAnnotationOfExact(executableElement));

      final routePrefix = routesAnnotation.peek('prefix')?.stringValue ?? '';

      return _routeType
          .annotationsOfExact(executableElement)
          .map(ConstantReader.new)
          .map((routeAnnotation) {
        final route = routeAnnotation.read('route').stringValue;

        return RouteHandler(
          element: executableElement,
          schemasRegistry: schemasRegistry,
          path: '$routePrefix$route',
          method: routeAnnotation.read('verb').stringValue,
          security: (openApiAnnotation.peek('security')?.mapReader ?? const {}).map((key, value) {
            return MapEntry(
              key.stringValue,
              value.listReader.map((e) => e.stringValue).toList(),
            );
          }),
          requestQuery: openApiAnnotation.peek('requestQuery')?.typeValue,
          requestBody: openApiAnnotation.peek('requestBody')?.typeValue,
        );
      });
    }).toList();

    final routesHandler = RoutesHandler(
      config: config,
      schemasRegistry: schemasRegistry,
      routes: routes,
    );

    final openApi = routesHandler.buildOpenApi();
    final rawOpenApi = organizeOpenApi(openApi.toJson());
    return YamlEncoder(
      shouldMultilineStringInBlock: false,
      toEncodable: (o) => o.toJson(),
    ).convert(rawOpenApi);
  }

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final libraries = await _findLibraryWithRoute(buildStep).toList();

    final result = _generate(libraries);

    await buildStep.writeAsString(buildStep.allowedOutputs.single, result);
  }
}
