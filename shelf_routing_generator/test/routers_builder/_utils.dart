import 'dart:convert';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:shelf_routing_generator/run_router_builder.dart';

Future<String?> testRouterBuilder({
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
  return files[AssetId(package, 'example.router.g.part')]
      ?.replaceAll(RegExp(r'//[^\n]*\n'), '')
      .split('\n')
      .where((e) => e.isNotEmpty)
      .join('\n');
}

Future<String?> testRoutingBuilder({
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
  return files[AssetId(package, 'example.routing.g.part')]
      ?.replaceAll(RegExp(r'//[^\n]*\n'), '')
      .split('\n')
      .where((e) => e.isNotEmpty)
      .join('\n');
}
