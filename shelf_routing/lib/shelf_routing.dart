library shelf_routing;

import 'package:meta/meta_meta.dart';

export 'package:shelf_routing/src/get_request_extension.dart';
export 'package:shelf_routing/src/json_response.dart';
export 'package:shelf_routing/src/route.dart';
export 'package:shelf_routing/src/utils.dart';

class GenerateRouterFor {
  final List<Type> controllers;

  const GenerateRouterFor(this.controllers);
}

@Target({TargetKind.classType})
class Routing {
  final String prefix;

  const Routing({required this.prefix});
}

@Target({TargetKind.method})
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
