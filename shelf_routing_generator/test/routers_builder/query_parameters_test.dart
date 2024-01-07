import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../example/lib/query_parameters.dart';
import '../_utils.dart';

class _MockQueryParametersController extends Mock implements QueryParametersController {}

class _FakeRequest extends Fake implements Request {}

void main() {
  late _MockQueryParametersController controller;

  setUp(() {
    controller = _MockQueryParametersController();

    registerFallbackValue(_FakeRequest());

    throwOnMissingStub(controller, exceptionBuilder: (_) => Response.ok(null));
  });

  tearDown(resetMocktailState);

  group('single query parameters', () {
    test('with passing all parameters', () async {
      final request = createRequest(
        controller: controller,
        route: Route.get('/single'),
        queryParameters: {
          'integer': '1',
          'double': '1.1',
          'string': 'string',
          'string-or-null': 'stringOrNull',
          'custom-parser': DateTime.utc(2000).toIso8601String(),
        },
      );

      final response = await QueryParametersController.router.call(request);

      expect(response.statusCode, 200);

      verify(() {
        return controller.single(
          any(),
          integer: 1,
          double: 1.1,
          string: 'string',
          stringOrNull: 'stringOrNull',
          customParser: DateTime.utc(2000),
        );
      });
    });

    test('with missing parameters', () async {
      final request = createRequest(
        controller: controller,
        route: Route.get('/single'),
        queryParameters: {
          'integer': '1',
          'string': 'string',
        },
      );

      final response = await QueryParametersController.router.call(request);

      expect(response.statusCode, 200);

      verify(() {
        return controller.single(
          any(),
          integer: 1,
          double: null,
          string: 'string',
          stringOrNull: null,
          customParser: null,
        );
      });
    });
  });

  // test('list query parameters', () async {
  //   final request = createRequest(
  //     controller: QueryParametersController(),
  //     route: Route.post('/text'),
  //   );
  //   final response = await QueryParametersController.router.call(request);
  //
  //   expect(response.statusCode, 200);
  // });
}
