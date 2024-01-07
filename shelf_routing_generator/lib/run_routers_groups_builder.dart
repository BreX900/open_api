import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:shelf_routing/shelf_routing.dart';
import 'package:shelf_routing_generator/src/routers_groups_file_schema.dart';
import 'package:source_gen/source_gen.dart';

Builder runRoutersGroupsBuilder(BuilderOptions options) {
  return LibraryBuilder(
    const RouterGroupGenerator(),
    generatedExtension: '.routers.dart',
    options: options,
  );
}

class GenerateRouterForGroupHandler {
  final String name;

  const GenerateRouterForGroupHandler._(this.name);

  factory GenerateRouterForGroupHandler.from(ConstantReader annotation) {
    return GenerateRouterForGroupHandler._(annotation.read('name').stringValue);
  }
}

class RouterGroupGenerator extends GeneratorForAnnotation<GenerateRouterForGroup> {
  const RouterGroupGenerator();

  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final group = GenerateRouterForGroupHandler.from(annotation);

    final schemas = await buildStep
        .findAssets(Glob('**/*${RoutersGroupsFileSchema.extension}'))
        .asyncMap(buildStep.readAsString)
        .map(jsonDecode)
        .cast<Map<String, dynamic>>()
        .map(RoutersGroupsFileSchema.fromJson)
        .where((e) => e.groups.containsKey(group.name))
        .toList();

    // Generate code

    final varName = '\$${group.name}Router';

    final routersImportsCode = schemas.map((e) => "import '${e.library}';").join('\n');

    final mountedRouters = schemas.expand((e) => e.groups[group.name] ?? const []).map((group) {
      return '..mount(\'${group.prefix}\', ${group.code})\n';
    }).join();

    return '''
import 'package:shelf_router/shelf_router.dart';
$routersImportsCode

Router get $varName => Router()
$mountedRouters;''';
  }
}
