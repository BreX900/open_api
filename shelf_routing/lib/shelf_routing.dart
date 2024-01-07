library shelf_routing;

import 'package:meta/meta_meta.dart';

export 'package:shelf_router/shelf_router.dart' hide Route;
export 'package:shelf_routing/src/getter.dart';
export 'package:shelf_routing/src/json_response.dart';
export 'package:shelf_routing/src/route.dart';
export 'package:shelf_routing/src/utils.dart';

@Target({TargetKind.function, TargetKind.topLevelVariable, TargetKind.classType})
class GenerateRouterForGroup {
  final String name;

  const GenerateRouterForGroup(this.name);
}

@Target({TargetKind.classType})
class RouteGroup {
  final String? name;
  final String? prefix;

  const RouteGroup({this.name, this.prefix});
}

class RouteHeader {
  final String name;

  const RouteHeader({required this.name});
}

enum BadRequestPosition { header, path, queryParameter, body }

class BadRequestException implements Exception {
  final BadRequestPosition position;
  final Object error;
  final StackTrace stackTrace;
  final String? name;

  BadRequestException.header(
    this.error,
    this.stackTrace,
    String this.name,
  ) : position = BadRequestPosition.header;

  BadRequestException.path(this.error, this.stackTrace)
      : position = BadRequestPosition.path,
        name = null;

  BadRequestException.queryParameter(this.error, this.stackTrace, String this.name)
      : position = BadRequestPosition.queryParameter;

  BadRequestException.body(this.error, this.stackTrace)
      : position = BadRequestPosition.body,
        name = null;

  @override
  String toString() => 'Missing or invalid query parameter `$name`.';
}
