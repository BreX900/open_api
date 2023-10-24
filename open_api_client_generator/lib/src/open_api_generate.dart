import 'dart:async';
import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:open_api_client_generator/src/api_specs.dart';
import 'package:open_api_client_generator/src/builders/build_api_class.dart';
import 'package:open_api_client_generator/src/builders/build_schema_class.dart';
import 'package:open_api_client_generator/src/client_codecs/client_codec.dart';
import 'package:open_api_client_generator/src/code_utils/codecs.dart';
import 'package:open_api_client_generator/src/data_codecs/data_codec.dart';
import 'package:open_api_client_generator/src/options/context.dart';
import 'package:open_api_client_generator/src/options/options.dart';
import 'package:open_api_client_generator/src/plugins/plugin.dart';
import 'package:open_api_client_generator/src/utils/extensions.dart';
import 'package:open_api_spec/open_api.dart';
import 'package:open_api_spec/open_api_spec.dart';

Future<void> generateApi({
  required Options options,
  required DataCodec dataCodec,
  required ClientCodec clientCodec,
  List<Plugin> plugins = const [],
  DartFormatter? formatter,
}) async {
  final timer = DateTime.now();
  print('StartAt: $timer');

  final works = <Future>[];
  final allPlugins = <Plugin>[
    if (clientCodec is Plugin) clientCodec as Plugin,
    if (dataCodec is Plugin) dataCodec as Plugin,
    if (dataCodec.collectionCodec is Plugin) dataCodec.collectionCodec as Plugin,
    ...plugins
  ];
  await Future.wait(allPlugins.map((plugin) async => await plugin.onStart()));
  final rawOpenApi = await readOpenApiWithRefs(options.input);
  print('ReadSpecs: ${DateTime.now().difference(timer)}');

  var openApi = OpenApi.fromJson(rawOpenApi);
  openApi = await allPlugins.asyncFold(openApi, (openApi, plugin) {
    return plugin.onSpecification(rawOpenApi, openApi);
  });
  print('ParseSpecs: ${DateTime.now().difference(timer)}');

  final versions = openApi.openapi.split('.');
  if (versions.length != 3) {
    final majorVersion = int.parse(versions[0]);
    if (majorVersion < 3 || majorVersion > 3) {
      throw StateError('Openapi version not supported ${openApi.openapi}');
    }
  }

  final emitter = DartEmitter(
    orderDirectives: true,
    useNullSafetySyntax: true,
    allocator: Allocator(),
  );
  formatter ??= DartFormatter(pageWidth: 100);

  final codecs = ApiCodecs(options: options);

  final context = Context(
    options: options,
    codecs: codecs,
  );

// Api Class and data classes

  final apiFileName = '${options.outputApiFileTitle}.dart';
  final buildSchemaClass = BuildSchemaClass(
    context: context,
  );
  final buildApiClass = BuildApiClass(
    context: context,
    clientCodec: clientCodec,
    dataCodec: dataCodec,
    buildSchemaClass: buildSchemaClass,
  );

  var apiSpec = buildApiClass(openApi.paths);
  apiSpec = allPlugins.fold(apiSpec, (spec, plugin) => plugin.onApiClass(openApi, spec));

  final dataSpecs = buildSchemaClass.apiSpecs.map<Spec>((apiSpec) {
    switch (apiSpec) {
      case ApiClass():
        var spec = dataCodec.buildDataClass(apiSpec);
        spec = allPlugins.fold(spec, (spec, plugin) => plugin.onDataClass(apiSpec.schema, spec));
        return spec;
      case ApiEnum():
        var spec = dataCodec.buildDataEnum(apiSpec);
        spec = allPlugins.fold(spec, (spec, plugin) => plugin.onDataEnum(apiSpec.schema, spec));
        return spec;
    }
  });

  var librarySpec = Library((b) => b
    ..ignoreForFile.addAll([
      'unnecessary_brace_in_string_interps',
      'no_leading_underscores_for_local_identifiers',
    ])
    ..body.add(apiSpec)
    ..body.addAll(dataSpecs));
  librarySpec = allPlugins.fold(librarySpec, (spec, plugin) => plugin.onLibrary(openApi, spec));

  final page = formatter.format('${librarySpec.accept(emitter)}');
  works.add(File('${options.outputFolder}/$apiFileName').writeAsString(page));

  for (final plugin in allPlugins) {
    final result = plugin.onFinish();
    if (result is Future<void>) works.add(result);
  }

  await Future.wait(works);
  // ignore: avoid_print
  print('TotalTime: ${DateTime.now().difference(timer)}');
}
