import 'package:shelf_routing/shelf_routing.dart';

class ApiRouteGroup extends RoutesGroup {
  const ApiRouteGroup({String? prefix})
      : super(
          prefix: '/v1${prefix ?? ''}',
        );
}
