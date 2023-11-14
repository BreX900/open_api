// ignore_for_file: always_use_package_imports

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'api_client.dart';
import 'dart_api_client.dart';

DartApiClient createDartApiClient() => WebApiClient();

class WebApiClient extends ApiClient implements DartApiClient {
  WebApiClient();

  @override
  Future<ApiClientResponse> onSend(ApiClientRequest request) async {
    final platformRequest = HttpRequest()
      ..open(request.method, '${request.uri}')
      ..responseType = 'arraybuffer';

    request.headers.forEach((key, value) => platformRequest.setRequestHeader(key, value.join(',')));

    final completer = Completer<ApiClientResponse>();

    unawaited(platformRequest.onLoad.first.then((_) {
      final body = (platformRequest.response as ByteBuffer).asUint8List();
      completer.complete(ApiClientResponse(
        request: request,
        statusCode: platformRequest.status!,
        headers:
            platformRequest.responseHeaders.map((key, value) => MapEntry(key, value.split(','))),
        data: jsonDecode(utf8.decode(body)),
      ));
    }));

    unawaited(platformRequest.onError.first.then((_) {
      // Unfortunately, the underlying XMLHttpRequest API doesn't expose any
      // specific information about the error itself.
      completer.completeError('XMLHttpRequest error.', StackTrace.current);
    }));

    platformRequest.send(utf8.encode(jsonEncode(request.data)));

    return await completer.future;
  }
}
