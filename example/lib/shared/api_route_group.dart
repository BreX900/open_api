import 'package:shelf_routing/shelf_routing.dart';

@GenerateRouterForGroup(ApiRouteGroup.name$)
class ApiRouteGroup extends RouteGroup {
  static const String name$ = 'api';

  const ApiRouteGroup({String? prefix})
      : super(
          name: ApiRouteGroup.name$,
          prefix: '/v1${prefix ?? ''}',
        );
}
