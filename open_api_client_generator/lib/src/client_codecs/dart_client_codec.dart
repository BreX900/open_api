import 'package:open_api_client_generator/src/client_codecs/abstract_client_codec.dart';

class DartClientCodec extends AbstractClientCodec {
  const DartClientCodec({
    required super.options,
  });

  @override
  List<String> get filesPaths => [
        ...super.filesPaths,
        '${root.path}/dart_api_client.dart',
        '${root.path}/io_api_client.dart',
        '${root.path}/web_api_client.dart',
      ];
}
