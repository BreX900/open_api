import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '_utils.dart';

void main() {
  test('GET route query parameters', () async {
    final source = r'''
  import 'package:shelf/shelf.dart';
  import 'package:shelf_router/shelf_router.dart';
  
  part 'example.g.dart';
  
  class Controller {
    static Router get router => _$ControllerRouter;
  
    @Route.get('/get')
    Response get(
      Request request, {
      
      required bool boolean,
      required int integer,
      required double float,
      required num number,
      required String string,
      
      int? integerOrNull,
      String? stringOrNull,
      
      required List<int>? integerList,
      required List<String>? stringList,
      
      List<int>? integerListOrNull,
      List<String>? stringListOrNull,
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
      boolean: $parseQueryParameters(
          request, 'boolean', (vls) => bool.parse(vls.single)),
      integer: $parseQueryParameters(
          request, 'integer', (vls) => int.parse(vls.single)),
      float: $parseQueryParameters(
          request, 'float', (vls) => double.parse(vls.single)),
      number: $parseQueryParameters(
          request, 'number', (vls) => num.parse(vls.single)),
      string: $parseQueryParameters(request, 'string', (vls) => vls.single),
      integerOrNull: $parseQueryParameters(request, 'integer-or-null',
          (vls) => vls.isNotEmpty ? int.parse(vls.single) : null),
      stringOrNull: $parseQueryParameters(request, 'string-or-null',
          (vls) => vls.isNotEmpty ? vls.single : null),
      integerList: $parseQueryParameters(
          request, 'integer-list', (vls) => vls.map(int.parse).toList()),
      stringList: $parseQueryParameters(request, 'string-list', (vls) => vls),
      integerListOrNull: $parseQueryParameters(request, 'integer-list-or-null',
          (vls) => vls.map(int.parse).toList()),
      stringListOrNull:
          $parseQueryParameters(request, 'string-list-or-null', (vls) => vls),
    );
  });''');
  });
}
