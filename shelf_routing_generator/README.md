Shelf Router Generator
Shelf makes it easy to build web applications in Dart by composing request handlers. The shelf_router package offers a request router for Shelf. this package enables generating a shelf_route.Router from annotations in code.

This package should be a development dependency along with package build_runner, and used with package shelf and package shelf_router as dependencies.

dependencies:
shelf: ^0.7.5
shelf_router: ^0.7.0+1
dev_dependencies:
shelf_router_generator: ^0.7.0+1
build_runner: ^1.3.1
Once your code have been annotated as illustrated in the example below the generated part can be created with pub run build_runner build.

Example
```dart
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_routing/shelf_routing.dart';
import 'userservice.routers.dart';

part 'userservice.g.dart'; // generated with 'pub run build_runner build'

class UserController {
  final DatabaseConnection connection;

  UserService(this.connection);

  @Route.get('/users/')
  Future<JsonResponse<List<dynamic>>> listUsers(Request request, {String? query}) async {
    return Response.ok('["user1"]');
  }

  @Route.get('/users/<userId>')
  Future<Response> fetchUser(Request request, int userId) async {
    if (userId == 1) {
      return Response.ok('user1');
    }
    return Response.notFound('no such user');
  }

  // Create router using the generate function defined in 'userservice.g.dart'.
  Router get router => _$userServiceRouter(this);
}

// Define a router group to create a router with all routers.
class ExampleRoutesGroup extends RoutesGroup {
  const ExampleRoutesGroup({super.prefix});
}

void main() async {
// You can setup context, database connections, cache connections, email
// services, before you create an instance of your service.
  final connection = await DatabaseConnection.connect('localhost:1234');

// Create an instance of your service, usine one of the constructors you've
// defined.
  var service = UserService(connection);
// Service request using the router, note the router can also be mounted.
  var router = Pipeline().addMiddleware().addHandler($exampleRoutesGroup);
  var server = await io.serve(router.handler, 'localhost', 8080);
}
```