import 'package:shelf_routing/shelf_routing.dart';

class ApiRouterGroup extends Routing {
  const ApiRouterGroup({String? prefix})
      : super(
          prefix: '/v1${prefix ?? ''}',
        );
}
