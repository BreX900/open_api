// ignore_for_file: always_use_package_imports

import 'api_client.dart';
import 'io_api_client.dart' if (dart.html) 'web_api_client.dart';

abstract interface class DartApiClient implements ApiClient {
  factory DartApiClient() => createDartApiClient();
}
