import 'dart:io';

import 'package:open_api_client_generator/open_api_client_generator.dart';

void main(List<String> args) async {
  final root = './example/google_maps';
  final codeDir = Directory('$root/code');
  if (!codeDir.existsSync()) codeDir.createSync();

  final options = Options(
    input: Uri.file('$root/specification/index.yml'),
    outputFolder: codeDir.path,
    apiClassName: 'GoogleMapsApi',
  );
  await generateApi(
    options: options,
    clientCodec: DartClientCodec(options: options),
    dataCodec: JsonSerializableDataCodec(
      collectionCodec: FastImmutableCollectionCodec(),
      classFieldRename: FieldRename.snake,
    ),
    plugins: [WriteOpenApiPlugin(options: options)],
  );
}
