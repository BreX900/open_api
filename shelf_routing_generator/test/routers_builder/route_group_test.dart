import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '_utils.dart';

void main() {
  test('success generate a schema', () async {
    final source = r'''
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_routing/shelf_routing.dart';

part 'example.g.dart';

@RouteGroup(name: 'example')
class Controller {
  static Router get router => _$ControllerRouter;

  @Route.get('/get')
  Response get(Request request) => throw UnimplementedError();
}''';

    final assets = await testRouterBuilder(source: source);

    expect(assets.schema, {
      "library": "asset:example/example.dart",
      "groups": {
        "example": [
          {"prefix": "/", "code": "Controller.router"}
        ]
      }
    });
  });

  test('not generate a schema because not has a group annotation', () async {
    final source = r'''
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'example.g.dart';

class Controller {
  static Router get router => _$ControllerRouter;

  @Route.get('/get')
  Response get(Request request) => throw UnimplementedError();
}''';

    final assets = await testRouterBuilder(source: source);

    expect(assets.schema, null);
  });

  test('not generate a schema because annotation not has a name', () async {
    final source = r'''
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_routing/shelf_routing.dart';

part 'example.g.dart';

@RouteGroup(prefix: '/example')
class Controller {
  static Router get router => _$ControllerRouter;

  @Route.get('/get')
  Response get(Request request) => throw UnimplementedError();
}''';

    final assets = await testRouterBuilder(source: source);

    expect(assets.schema, null);
  });
}
