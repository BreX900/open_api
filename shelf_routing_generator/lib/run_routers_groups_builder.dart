import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:shelf_routing/shelf_routing.dart';
import 'package:shelf_routing_generator/src/routers_groups_file_schema.dart';
import 'package:shelf_routing_generator/src/utils.dart';
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

class RouterGroupGenerator extends Generator {
  const RouterGroupGenerator();

  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    final classes = library.classes.where((element) {
      return TypeChecker.fromRuntime(RoutesGroup).isAssignableFrom(element);
    });

    final code = await Future.wait(classes.map((class$) => generateForClass(class$, buildStep)));

    return code.join('\n\n');
  }

  Future<String> generateForClass(ClassElement element, BuildStep buildStep) async {
    final groupId = element.id;

    final schemas = await buildStep
        .findAssets(Glob('**/*${RoutersGroupsFileSchema.extension}'))
        .asyncMap(buildStep.readAsString)
        .map(jsonDecode)
        .cast<Map<String, dynamic>>()
        .map(RoutersGroupsFileSchema.fromJson)
        .where((e) => e.groups.any((e) => e.id == groupId))
        .toList();

    final libraries = schemas.map((e) => e.library);
    final groups = schemas.expand((e) => e.groups.where((e) => e.id == groupId));

    // Generate code
    final groupName = element.name;
    final varName = codePublicVarName('${groupName}Router');

    final routersImportsCode = libraries.map((library) => "import '$library';").join('\n');

    final mountedRouters = groups.map((group) {
      return '..mount(\'${group.prefix}\', ${group.code})\n';
    }).join();

    return '''
import 'package:shelf_router/shelf_router.dart';
$routersImportsCode

Router get $varName => Router()
$mountedRouters;''';
  }
}
