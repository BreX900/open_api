import 'package:shelf_open_api_generator/src/specs/specs_serialization.dart';

part 'info_specs.g.dart';

/// Version: 3.0.3
@SpecsSerializable()
class InfoOpenApi {
  final String title;
  final String? description;
  final String? termsOfService;
  // final ContactOpenApi? contact;
  // final LicenseOpenApi? license;
  final String version;

  const InfoOpenApi({
    required this.title,
    this.description,
    this.termsOfService,
    required this.version,
  });

  factory InfoOpenApi.fromJson(Map<String, dynamic> map) => _$InfoOpenApiFromJson(map);
  Map<String, dynamic> toJson() => _$InfoOpenApiToJson(this);
}

/// Version: 3.0.3
@SpecsSerializable()
class ServerOpenApi {
  final String url;
  final String? description;
  // final Map<String, ServerVariableOpenApi>? variables;

  const ServerOpenApi({
    required this.url,
    this.description,
    // this.variables,
  });

  factory ServerOpenApi.fromJson(Map<String, dynamic> map) => _$ServerOpenApiFromJson(map);
  Map<String, dynamic> toJson() => _$ServerOpenApiToJson(this);
}

/// Version: 3.0.3
@SpecsSerializable()
class TagOpenApi {
  final String name;
  final String? description;
  // final ExternalDocsOpenApi? externalDocs;

  const TagOpenApi({
    required this.name,
    this.description,
  });

  factory TagOpenApi.fromJson(Map<String, dynamic> map) => _$TagOpenApiFromJson(map);
  Map<String, dynamic> toJson() => _$TagOpenApiToJson(this);
}
