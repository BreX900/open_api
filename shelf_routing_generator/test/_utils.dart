import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Request createRequest({
  required Object controller,
  required Route route,
  Map<String, dynamic>? queryParameters,
}) {
  return Request(route.verb, Uri.https('example.com', route.route, queryParameters), context: {
    '_get': <T extends Object>() => controller as T,
  });
}
