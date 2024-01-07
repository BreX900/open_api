import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '_utils.dart';

void main() {
  test('parsing headers', () async {
    final source = r'''
  import 'package:shelf/shelf.dart';
  import 'package:shelf_router/shelf_router.dart';
  import 'package:shelf_routing/shelf_routing.dart';
  
  part 'example.g.dart';
  
  class Controller {
    static Router get router => _$ControllerRouter;
  
    @Route.get('/get')
    Response get(
      Request request, {
      
      @RouteHeader() required bool boolean,
      @RouteHeader() required int integer,
      @RouteHeader() required double float,
      @RouteHeader() required num number,
      @RouteHeader() required String string,
      
      @RouteHeader() int? integerOrNull,
      @RouteHeader() String? stringOrNull,
      
      @RouteHeader() required List<int>? integerList,
      @RouteHeader() required List<String>? stringList,
      
      @RouteHeader() List<int>? integerListOrNull,
      @RouteHeader() List<String>? stringListOrNull,
    }) {
      throw UnimplementedError();
    }
  }''';

    final assets = await testRouterBuilder(source: source);

    expect(assets.routers, r'''
Router get _$ControllerRouter => Router()
  ..add('GET', r'/get', (Request request) async {
    final $ = request.get<Controller>();
    return await $.get(
      request,
      boolean:
          $parseHeaders(request, 'boolean', (vls) => bool.parse(vls.single)),
      integer:
          $parseHeaders(request, 'integer', (vls) => int.parse(vls.single)),
      float: $parseHeaders(request, 'float', (vls) => double.parse(vls.single)),
      number: $parseHeaders(request, 'number', (vls) => num.parse(vls.single)),
      string: $parseHeaders(request, 'string', (vls) => vls.single),
      integerOrNull: $parseHeaders(request, 'integer-or-null',
          (vls) => vls.isNotEmpty ? int.parse(vls.single) : null),
      stringOrNull: $parseHeaders(request, 'string-or-null',
          (vls) => vls.isNotEmpty ? vls.single : null),
      integerList: $parseHeaders(
          request, 'integer-list', (vls) => vls.map(int.parse).toList()),
      stringList: $parseHeaders(request, 'string-list', (vls) => vls),
      integerListOrNull: $parseHeaders(request, 'integer-list-or-null',
          (vls) => vls.map(int.parse).toList()),
      stringListOrNull:
          $parseHeaders(request, 'string-list-or-null', (vls) => vls),
    );
  });''');
  });
}
