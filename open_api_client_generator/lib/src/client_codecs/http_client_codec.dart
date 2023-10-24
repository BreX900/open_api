import 'package:open_api_client_generator/src/client_codecs/abstract_client_codec.dart';

class HttpClientCodec extends AbstractClientCodec {
  const HttpClientCodec({
    required super.options,
  });

  @override
  List<String> get filesPaths => [...super.filesPaths, '${root.path}/http_api_client.dart'];
}
