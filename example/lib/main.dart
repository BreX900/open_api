import 'dart:io';

import 'package:example/main.routing.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_open_api/shelf_routing.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';

@Routing(
  varName: 'controllersRouter',
  generateFor: ['**/*_controller.dart'],
)
void main() async {
  final rootRouter = Router()
    ..mount('/', $controllersRouter)
    ..mount('/swagger', SwaggerUI('public/example.open_api.yaml', title: 'Swagger Example Api'))
    ..mount('/', createStaticHandler('public'));

  // Configure a pipeline.
  final handler = Pipeline().addHandler(rootRouter);

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;
  // For running in containers, we respect the PORT environment variable.
  final server = await serve(handler, ip, 8080);

  final url = 'http://${server.address.address}:${server.port}';
  print('Server listening on $url -> Swagger: $url/swagger');
}
