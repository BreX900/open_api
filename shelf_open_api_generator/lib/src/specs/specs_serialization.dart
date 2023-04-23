import 'package:build/build.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shelf_open_api_generator/src/specs/base_specs.dart';
import 'package:shelf_open_api_generator/src/specs/ref_or_specs.dart';
import 'package:shelf_open_api_generator/src/specs/schema.dart';
import 'package:shelf_open_api_generator/src/specs/security_open_api.dart';

class SpecsSerializable extends JsonSerializable {
  const SpecsSerializable()
      : super(
          createFactory: true,
          createToJson: true,
          includeIfNull: false,
          converters: const [
            RefOrParamOpenApiConverter(),
            RefOrSchemaOpenApiConverter(),
            RefOrSecuritySchemeOpenApiConverter(),
          ],
        );
}

class RefOrParamOpenApiConverter extends _RefOrOpenApiConverter<ParameterOpenApi> {
  const RefOrParamOpenApiConverter() : super(ParameterOpenApi.fromJson);
}

class RefOrSchemaOpenApiConverter extends _RefOrOpenApiConverter<SchemaOrRefOpenApi> {
  const RefOrSchemaOpenApiConverter() : super(SchemaOrRefOpenApi.fromJson);
}

class RefOrSecuritySchemeOpenApiConverter extends _RefOrOpenApiConverter<SecuritySchemeOpenApi> {
  const RefOrSecuritySchemeOpenApiConverter() : super(SecuritySchemeOpenApi.fromJson);
}

class _RefOrOpenApiConverter<T extends RefOrOpenApi<T>>
    extends JsonConverter<RefOrOpenApi<T>, Map<String, dynamic>> {
  final T Function(Map<String, dynamic>) deserialize;

  const _RefOrOpenApiConverter(this.deserialize);

  @override
  RefOrOpenApi<T> fromJson(Map<String, dynamic> json) {
    final ref = json['\$ref'];
    if (ref != null) {
      return RefOpenApi(ref: ref);
    } else {
      return deserialize(json);
    }
  }

  @override
  Map<String, dynamic> toJson(RefOrOpenApi<T> object) {
    return object.toJson();
  }
}

bool? $nullIfFalse(bool value) => value ? true : null;

Object? $nullIfEmpty(Object? value) {
  if (value is List) {
    return value.isEmpty ? null : value;
  } else if (value is Map<String, dynamic>) {
    return value.isEmpty ? null : value;
  } else if (value is String) {
    return value.isEmpty ? null : value;
  }
  log.severe("Unsupported type: $value");
  return value;
}
