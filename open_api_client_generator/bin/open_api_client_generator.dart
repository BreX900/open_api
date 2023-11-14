import 'package:args/args.dart';
import 'package:open_api_client_generator/open_api_client_generator.dart';
import 'package:open_api_client_generator/src/data_codecs/built_value_data_codec.dart';

void main(List<String> arguments) async {
  final argParser = ArgParser()
    ..addFlag('help', negatable: false, defaultsTo: false)
    ..addOption('input',
        mandatory: true,
        help:
            'Path to the file or link to the OpenApi specification file in json, yaml or yml format.')
    ..addOption('api-class-name', defaultsTo: 'Api')
    ..addOption('data-classes-postfix')
    ..addOption('output-folder', mandatory: true)
    ..addOption('client', allowed: ['dart', 'http', 'dio'])
    ..addOption('collection', allowed: ['fast_immutable_collection', 'built_collection'])
    ..addOption('data', mandatory: true, allowed: ['json_serializable', 'built_value'])
    ..addMultiOption('plugins', allowed: ['mek_data_class'])
    ..addSeparator('Data Codec: json_serializable')
    ..addFlag('d-js-implicit-create', defaultsTo: true)
    ..addOption('d-js-class-field-rename')
    ..addOption('d-js-enum-field-rename');

  final args = argParser.parse(arguments);

  if (args['help']) {
    print(argParser.usage);
    return;
  }

  final input = args['input'] as String;

  final options = Options(
    input: input.contains('://') ? Uri.parse(input) : Uri.file(input),
    apiClassName: args['api-class-name'],
    dataClassesPostfix: args['data-classes-postfix'],
    outputFolder: args['output-folder'],
  );

  final client = switch (args['client']) {
    'dart' => DartClientCodec(options: options),
    'http' => HttpClientCodec(options: options),
    'dio' => DioClientCodec(),
    _ => AbstractClientCodec(options: options),
  };

  final data = _resolveDataCodec(args);

  final plugins = (args['plugins'] as List<String>).map((plugin) {
    return switch (plugin) {
      'mek_data_class' => MekDataClassPlugin(),
      _ => throw 'Plugin not supported',
    };
  }).toList();

  await generateApi(
    options: options,
    clientCodec: client,
    dataCodec: data,
    plugins: plugins,
  );
}

DataCodec _resolveDataCodec(ArgResults args) {
  final collection = switch (args['client']) {
    'fast_immutable_collection' => FastImmutableCollectionCodec(),
    'built_collection' => BuiltCollectionCodec(),
    _ => DartCollectionCodec(),
  };

  switch (args['data']) {
    case 'json_serializable':
      return JsonSerializableDataCodec(
        collectionCodec: collection,
        implicitCreate: args['d-js-implicit-create'],
        classFieldRename: FieldRename.fromName(args['d-js-class-field-rename']),
        enumFieldRename: FieldRename.fromName(args['d-js-enum-field-rename']),
      );
    case 'built_value':
      return BuiltValueDataCodec(
        collectionCodec: collection,
      );
    default:
      throw '';
  }
}
