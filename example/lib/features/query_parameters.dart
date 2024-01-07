import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_routing/shelf_routing.dart';

part 'query_parameters.g.dart';

class QueryParametersController {
  static Router get router => _$QueryParametersControllerRouter;

  const QueryParametersController();

  @Route.get('/messages')
  Future<Response> fetchMessages(
    Request request, {
    required int userId,
    int? pageSize,
    int? pageCount,
    String? query,
    List<String>? keywords,
  }) async {
    // ...

    return Response.ok(null);
  }
}
