import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_routing/shelf_routing.dart';

part 'responses.g.dart';

class ResponsesController {
  static Router get router => _$ResponsesControllerRouter;

  const ResponsesController();

  @Route.get('/')
  Response sync(Request request) {
    // ...
    return Response.ok(null);
  }

  @Route.post('/')
  Future<Response> async(Request request) async {
    // ...
    return Response.ok(null);
  }
}
