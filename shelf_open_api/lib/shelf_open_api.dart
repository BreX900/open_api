/// Annotations for the shelf_open_api_generator library.
library shelf_open_api;

import 'package:meta/meta_meta.dart';

@TargetKind.method
class OpenApiRoute {
  final Map<String, List<String>> security;
  final Type? requestQuery;
  final Type? requestBody;

  const OpenApiRoute({
    this.security = const {},
    this.requestQuery,
    this.requestBody,
  });
}
