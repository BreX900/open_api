import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:shelf_routing/shelf_routing.dart';
import 'package:shelf_routing_generator/src/routers_groups_file_schema.dart';
import 'package:shelf_routing_generator/src/utils.dart';
import 'package:source_gen/source_gen.dart';

Builder runGroupsRouterBuilder(BuilderOptions options) {
  return LibraryBuilder(
    const GroupsRouterGenerator(),
    generatedExtension: '.router.dart',
    options: options,
  );
}

class GroupsRouterGenerator extends Generator {
  const GroupsRouterGenerator();

  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    final classes = library.classes.where((element) {
      return TypeChecker.fromRuntime(Routing).isAssignableFrom(element);
    });

    final code = await Future.wait(classes.map((class$) => generateForClass(class$, buildStep)));

    return code.join('\n\n');
  }

  Future<String> generateForClass(ClassElement element, BuildStep buildStep) async {
    final groupId = RouterGroupSchema.getUid(element);

    final schemas = await buildStep
        .findAssets(Glob('**/*${RouterGroupsAssetSchema.extension}'))
        .asyncMap(buildStep.readAsString)
        .map(jsonDecode)
        .cast<Map<String, dynamic>>()
        .map(RouterGroupsAssetSchema.fromJson)
        .map((e) => e.copyForGroup(groupId))
        .where((e) => e.groups.isNotEmpty)
        .toList();

    final imports = schemas.map((schema) {
      if (schema.id.uri.scheme == 'package') return '${schema.id.uri}';
      return p.relative(schema.id.path, from: p.dirname(buildStep.inputId.path));
    });
    final groups = schemas.expand((e) => e.groups.where((e) => e.uid == groupId));

    // Generate code
    final groupName = element.name;
    final varName = codePublicVarName('${groupName}Router');

    final routersImportsCode = imports.map((library) => "import '$library';").join('\n');

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
