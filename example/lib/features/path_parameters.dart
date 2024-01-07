import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_routing/shelf_routing.dart';

part 'path_parameters.g.dart';

@RouteHeader(name: 'app-route')
typedef AppRoute = Route;

@RouteGroup('/path-parameters')
class PathParametersController {
  static Router get router => _$PathParametersControllerRouter;

  const PathParametersController();

  @RouteHeader(name: 'route')
  @AppRoute.get('/<intParameter>')
  Future<Response> fetchMessages(Request request, int intParameter) async {
    // ...
    return Response.ok(null);
  }

  @AppRoute.post('/<stringParameter>')
  Future<Response> createMessage(Request request, String stringParameter) async {
    // ...
    return Response.ok(null);
  }

  @AppRoute.put('/<decimalParameter>')
  Future<Response> updateMessage(Request request, int decimalParameter) async {
    // ...
    return Response.ok(null);
  }
}
