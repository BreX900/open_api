import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:shelf_routing/shelf_routing.dart';
import 'package:shelf_routing_generator/src/routers_schema.dart';
import 'package:source_gen/source_gen.dart';

Builder runRoutingBuilder(BuilderOptions options) {
  return LibraryBuilder(
    const RoutingGenerator(),
    generatedExtension: '.routing.dart',
    options: options,
  );
}

class RoutingGenerator extends GeneratorForAnnotation<GenerateRouterForGroup> {
  const RoutingGenerator();

  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final routings = await buildStep
        .findAssets(Glob('**/*.routers.json'))
        .asyncMap(buildStep.readAsString)
        .map(jsonDecode)
        .cast<Map<String, dynamic>>()
        .map(RoutersSchema.fromJson)
        .toList();

    // Generate code

    final varName = '\$${element.name}Router';

    final routersImportsCode = routings.map((e) => "import '${e.library}';").join('\n');

    final mountedRouters = routings.expand((e) => e.handlers.entries).map((_) {
      final MapEntry(key: prefix, value: code) = _;
      return '..mount(\'$prefix\', $code)\n';
    }).join();

    return '''
import 'package:shelf_routing/shelf_routing.dart';
$routersImportsCode

Router get $varName => Router()
$mountedRouters;''';
  }
}
