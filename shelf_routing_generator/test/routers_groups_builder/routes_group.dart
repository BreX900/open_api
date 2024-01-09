import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../example/routes_group/route_group.routers.dart';
import '../../example/routes_group/routes_group.dart';
import '../_utils.dart';

class _MockRoutesGroupController extends Mock implements RoutesGroupController {}

class _MockRoutesGroupWithPrefixController extends Mock
    implements RoutesGroupWithPrefixController {}

class _FakeRequest extends Fake implements Request {}

void main() {
  late _MockRoutesGroupController controller;
  late _MockRoutesGroupWithPrefixController controllerWithPrefix;

  setUp(() {
    controller = _MockRoutesGroupController();
    controllerWithPrefix = _MockRoutesGroupWithPrefixController();

    registerFallbackValue(_FakeRequest());
  });

  tearDown(resetMocktailState);

  group('router for routes group tests', () {
    test('simple controller', () async {
      when(() => controller.sync(any())).thenReturn(Response.ok(null));

      final request = createRequest(
        controller: controller,
        route: Route.get('/'),
      );
      final response = await $exampleRoutesGroupRouter.call(request);

      expect(response.statusCode, 200);

      verify(() => controller.sync(any()));
    });

    test('async handler', () async {
      when(() => controller.sync(any())).thenReturn(Response.ok(null));

      final request = createRequest(
        controller: controllerWithPrefix,
        route: Route.post('/example'),
      );
      final response = await $exampleRoutesGroupRouter.call(request);

      expect(response.statusCode, 200);

      verify(() => controller.sync(any()));
    });
  });
}
