import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:open_api_client_generator/open_api_client_generator.dart';
import 'package:path/path.dart' as path_;

class AbstractClientCodec extends ClientCodec with Plugin {
  final Options options;

  Directory get root => Directory('./tools/clients');

  const AbstractClientCodec({
    required this.options,
  });

  @override
  Reference get type => Reference('ApiClient', './api_client.dart');

  @override
  List<String> get filesPaths => [...super.filesPaths, '${root.path}/api_client.dart'];

  @override
  String encodeSendMethod(
    String method,
    String path, {
    String? queryParametersVar,
    String? dataVar,
  }) {
    var sendMethod = 'await client.send(\'$method\', \'$path\'';
    if (queryParametersVar != null) sendMethod += ', queryParameters: $queryParametersVar';
    if (dataVar != null) sendMethod += ', data: $dataVar';
    sendMethod += ');';
    return sendMethod;
  }

  @override
  String encodeExceptionInstance(String responseVar) => 'ApiClientException.of($responseVar)';

  @override
  Future<void> onFinish() async {
    await Future.wait(filesPaths.map((e) async {
      await File(e).copy('${options.outputFolder}/${path_.basename(e)}');
    }));
  }
}
