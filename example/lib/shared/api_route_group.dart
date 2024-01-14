import 'package:shelf_routing/shelf_routing.dart';

class ApiRouterGroup extends Routable {
  const ApiRouterGroup({String? prefix})
      : super(
          prefix: '/v1${prefix ?? ''}',
        );
}
