import 'dart:convert';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:shelf_routing_generator/run_router_builder.dart';
import 'package:shelf_routing_generator/src/routers_groups_file_schema.dart';

Future<RouterBuilderAssets> testRouterBuilder({
  required String source,
}) async {
  const package = 'example';
  final writer = InMemoryAssetWriter();

  await testBuilder(
    runRouterBuilder(BuilderOptions.empty),
    {'$package|example.dart': source},
    reader: await PackageAssetReader.currentIsolate(),
    writer: writer,
  );

  final files = writer.assets.map((key, value) => MapEntry(key, utf8.decode(value)));
  print(files.values.toList());
  return RouterBuilderAssets(
    schema: jsonDecode(
        files[AssetId(package, 'example${RouterGroupsAssetSchema.extension}')] ?? 'null'),
    routers: files[AssetId(package, 'example.routers.g.part')]
        ?.replaceAll(RegExp(r'//[^\n]*\n'), '')
        .split('\n')
        .where((e) => e.isNotEmpty)
        .join('\n'),
  );
}

class RouterBuilderAssets {
  final Map<String, dynamic>? schema;
  final String? routers;

  const RouterBuilderAssets({
    required this.schema,
    required this.routers,
  });
}
