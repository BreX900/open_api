import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '_utils.dart';

void main() {
  test('GET router with Request and path parameter', () async {
    final source = r'''
  import 'package:shelf/shelf.dart';
  import 'package:shelf_router/shelf_router.dart';
  
  part 'example.g.dart';
  
  class Controller {
    static Router get router => _$ControllerRouter;
    
    @Route.get('/booleans/<boolean>')
    Response numbers(Request request, bool boolean) => throw UnimplementedError();
  
    @Route.post('/strings/<string>')
    Response strings(Request request, String string) => throw UnimplementedError();
    
    @Route.put('/numbers/<integer>/<db>/<number>')
    Response numbers(Request request, int integer, double float, num number) => throw UnimplementedError();
  }''';

    final assets = await testRouterBuilder(source: source);

    expect(assets.routers, r'''
Router get _$ControllerRouter => Router()
  ..add('GET', r'/booleans/<boolean>', (Request request, String boolean) async {
    final $ = request.get<Controller>();
    return await $.numbers(
      request,
      bool.parse(boolean),
    );
  })
  ..add('POST', r'/strings/<string>', (Request request, String string) async {
    final $ = request.get<Controller>();
    return await $.strings(
      request,
      string,
    );
  })
  ..add('PUT', r'/numbers/<integer>/<db>/<number>',
      (Request request, String integer, String float, String number) async {
    final $ = request.get<Controller>();
    return await $.numbers(
      request,
      int.parse(integer),
      double.parse(float),
      num.parse(number),
    );
  });''');
  });
}
