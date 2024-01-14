import 'dart:io';

import 'package:example/features/chats/controllers/chats_controller.dart';
import 'package:example/features/messages/controllers/messages_controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_routing/shelf_routing.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';

part 'main.g.dart';

@GenerateRouterFor([ChatsController, MessagesController])
Router get _apiRouter => _$apiRouter;

void main() => withHotreload(_runServer);

Future<HttpServer> _runServer() async {
  final rootRouter = Router()
    ..mount('/api', _apiRouter)
    ..mount('/swagger', SwaggerUI('public/example.open_api.yaml', title: 'Swagger Example Api'))
    ..mount('/', createStaticHandler('public'));

  // Configure a pipeline.
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(getterMiddleware(_getController))
      .addHandler(rootRouter);

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;
  // For running in containers, we respect the PORT environment variable.
  final server = await serve(handler, ip, 8080);

  final url = 'http://${server.address.address}:${server.port}';
  print('Server listening on $url -> Swagger: $url/swagger');

  return server;
}

const _controllers = <Type, Object Function()>{
  ChatsController: ChatsController.new,
  MessagesController: MessagesController.new,
};
T _getController<T extends Object>(Request request) {
  final controller = _controllers[T];
  if (controller == null) throw UnsupportedError('Unsupported $T');

  return controller() as T;
}
