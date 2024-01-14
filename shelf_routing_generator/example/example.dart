import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_routing/shelf_routing.dart';

// generated with 'pub run build_runner build'
import 'example.routers.dart';

part 'example.g.dart';

class User {
  final int id;
  final String name;

  const User({
    required this.id,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> map) => User(id: map['id'], name: map['name']);
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

// Define a router group to create a router with all routers.
class ExampleRoutesGroup extends Routing {
  const ExampleRoutesGroup({super.prefix});
}

@ExampleRoutesGroup()
class UserController {
  // Create router using the generate function defined in 'userservice.g.dart'.
  static Router get router => _$userControllerRouter;

  final DatabaseConnection connection;

  UserController(this.connection);

  @Route.get('/users')
  Future<List<dynamic>> listUsers(Request request, {String? query}) async {
    return ['user1'];
  }

  @Route.get('/users/<userId>')
  Future<Response> fetchUser(Request request, int userId) async {
    if (userId == 1) {
      return Response.ok('user1');
    }
    return Response.notFound('no such user');
  }

  @Route.post('/users')
  Future<JsonResponse<User>> createUser(Request request, User user) async {
    if (user.name.isEmpty) {
      return JsonResponse.badRequest('Missing name field');
    }
    return JsonResponse.ok(user);
  }
}

void main() async {
  // You can setup context, database connections, cache connections, email
  // services, before you create an instance of your service.
  final connection = await DatabaseConnection.connect('localhost:1234');

  // Define a function to inject your controllers.
  // You can use the get_it package.
  T get<T extends Object>(Request request) {
    return UserController(connection) as T;
  }

  // Service request using the router, note the router can also be mounted.
  final handler =
      Pipeline().addMiddleware(getterMiddleware(get)).addHandler($exampleRoutesGroupRouter);
  await serve(handler, 'localhost', 8080);
}
