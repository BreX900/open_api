import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '_utils.dart';

void main() {
  test('methods returns with Future<Response> or not', () async {
    final source = r'''
  import 'package:shelf/shelf.dart';
  import 'package:shelf_router/shelf_router.dart';
  
  part 'example.g.dart';
  
  class Controller {
    static Router get router => _$ControllerRouter;
  
    @Route.get('/get')
    Response get(Request request) => throw UnimplementedError();
    
    @Route.post('/post')
    Response<Response> get(Request request) => throw UnimplementedError();
  }''';

    // TODO: Test getters

    final assets = await testRouterBuilder(source: source);

    expect(assets.routers, r'''
Router get _$ControllerRouter => Router()
  ..add('GET', r'/get', (Request request) async {
    final $ = request.get<Controller>();
    return $.get(
      request,
    );
  })
  ..add('POST', r'/post', (Request request) async {
    final $ = request.get<Controller>();
    return await $.get(
      request,
    );
  })''');
  });

  test('simple methods', () async {
    final source = r'''
  import 'package:shelf/shelf.dart';
  import 'package:shelf_router/shelf_router.dart';
  
  part 'example.g.dart';
  
  class Controller {
    static Router get router => _$ControllerRouter;
  
    @Route.get('/get')
    Response get(Request request) => throw UnimplementedError();
    
    @Route.post('/post')
    Response<Response> get(Request request) => throw UnimplementedError();
  }''';

    // TODO: Test getters

    final assets = await testRouterBuilder(source: source);

    expect(assets.routers, r'''
Router get _$ControllerRouter => Router()
  ..add('GET', r'/get', (Request request) async {
    final $ = request.get<Controller>();
    return $.get(
      request,
    );
  })
  ..add('POST', r'/post', (Request request) async {
    final $ = request.get<Controller>();
    return await $.get(
      request,
    );
  })''');
  });
}
