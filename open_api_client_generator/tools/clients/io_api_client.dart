import 'dart:convert';
import 'dart:io';

import 'api_client.dart';
import 'dart_api_client.dart';

DartApiClient createDartApiClient() => IoApiClient();

class IoApiClient extends ApiClient implements DartApiClient {
  final HttpClient httpClient;

  IoApiClient([HttpClient? httpClient]) : httpClient = httpClient ?? HttpClient();

  @override
  Future<ApiClientResponse> onSend(ApiClientRequest request) async {
    final platformRequest = await httpClient.openUrl(request.method, request.uri);

    request.headers.forEach((key, value) {
      platformRequest.headers.set(key, value);
    });
    platformRequest.add(utf8.encode(jsonEncode(request.data)));

    final response = await platformRequest.close();
    final responseHeaders = <String, List<String>>{};
    response.headers.forEach((name, values) => responseHeaders[name] = values);

    return ApiClientResponse(
      request: request,
      statusCode: response.statusCode,
      headers: responseHeaders,
      data: jsonDecode(await utf8.decodeStream(response)),
    );
  }
}
