import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shelf_open_api_generator/src/specs/ref_or_specs.dart';
import 'package:shelf_open_api_generator/src/specs/specs_serialization.dart';
import 'package:shelf_open_api_generator/src/specs/utils.dart';

part 'schema.g.dart';

@SpecsSerializable()
class GroupMediaOpenApi with PrettyJsonToString {
  @JsonKey(name: 'application/json')
  final MediaOpenApi? json;

  @JsonKey(name: 'application/x-www-form-urlencoded')
  final MediaOpenApi? urlEncoded;

  @JsonKey(name: '*/*')
  final MediaOpenApi? any;

  const GroupMediaOpenApi({
    this.json,
    this.any,
    this.urlEncoded,
  });

  MediaOpenApi? get jsonOrAny => single; // TODO: json ?? any;

  MediaOpenApi? get single => json ?? any ?? urlEncoded;

  factory GroupMediaOpenApi.fromJson(Map<String, dynamic> map) => _$GroupMediaOpenApiFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$GroupMediaOpenApiToJson(this);
}

@SpecsSerializable()
class MediaOpenApi with PrettyJsonToString {
  final String? example;
  @JsonKey(toJson: $nullIfEmpty)
  final Map<String, dynamic> examples;

  final SchemaOrRefOpenApi schema;

  const MediaOpenApi({
    this.example,
    this.examples = const {},
    required this.schema,
  });

  factory MediaOpenApi.fromJson(Map<String, dynamic> map) => _$MediaOpenApiFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$MediaOpenApiToJson(this);
}

/// https://swagger.io/specification/#data-types
@JsonEnum()
enum TypeOpenApi {
  boolean,
  number,
  integer,
  string,
  array,
  object,
}

extension TypeOpenApiExt on TypeOpenApi {
  String toJson() => _$TypeOpenApiEnumMap[this]!;
  static TypeOpenApi? maybeFromJson(String? type) =>
      $enumDecodeNullable(_$TypeOpenApiEnumMap, type);
}

@JsonEnum()
enum FormatOpenApi {
  int32,
  int64,
  double,
  float,
  date,
  @JsonValue('date-time')
  dateTime,

  uuid,
  email,
  url,
  uri,

  /// File upload
  binary,
  base64,
}

extension FormatOpenApiExt on FormatOpenApi {
  String toJson() => _$FormatOpenApiEnumMap[this]!;
  static FormatOpenApi? maybeFromJson(String? type) =>
      $enumDecodeNullable(_$FormatOpenApiEnumMap, type);
}

// title
// multipleOf
// maximum
// exclusiveMaximum
// minimum
// exclusiveMinimum
// maxLength
// minLength
// pattern (This string SHOULD be a valid regular expression, according to the Ecma-262 Edition 5.1 regular expression dialect)
// maxItems
// minItems
// uniqueItems
// maxProperties
// minProperties
// required
// enum
@SpecsSerializable()
class SchemaOrRefOpenApi with PrettyJsonToString, RefOrOpenApi<SchemaOrRefOpenApi> {
  final String? description;
  final Object? example;

  @JsonKey(name: '\$ref')
  @override
  final String? ref; // "$ref": "#/definitions/Category"

  /// Is null when [ref] exist
  final TypeOpenApi? type;

  final FormatOpenApi? format;

  /// With [TypeOpenApi.integer] | [TypeOpenApi.string]
  @JsonKey(name: 'enum')
  final List<Object>? enum$;

  /// Must be present if the type is [TypeOpenApi.array]
  final SchemaOrRefOpenApi? items;

  /// With [TypeOpenApi.object]
  final Map<String, SchemaOrRefOpenApi>? properties;

  /// With [TypeOpenApi.object]. It define a Map<String, *>
  final SchemaOrRefOpenApi? additionalProperties;

  final List<SchemaOrRefOpenApi>? allOf;

  // final List<SchemaOrRefOpenApi> anyOf;

  // final List<SchemaOrRefOpenApi> oneOf;

  /// With [TypeOpenApi.object]
  final List<String>? required;

  @JsonKey(toJson: $nullIfFalse)
  final bool nullable;

  @JsonKey(name: 'default')
  final Object? default$;

  final Object? $original;

  /// A [schema] contains this property
  /// A property [name]
  bool canNull(String name, SchemaOrRefOpenApi schema) {
    if (schema.nullable) return true;
    if ((required ?? const []).contains(name)) return false;
    return true;
  }

  /// A [schema] contains this property
  /// A property [name]
  bool isRequired(String name) {
    if ((required ?? const []).contains(name)) return true;
    return false;
  }

  const SchemaOrRefOpenApi({
    this.description,
    this.example,
    this.type,
    this.format,
    this.enum$,
    this.items,
    this.ref,
    this.properties,
    this.additionalProperties,
    this.allOf,
    this.required,
    this.nullable = false,
    this.default$,
    this.$original,
  });

  bool get isClass => properties != null || allOf != null;

  bool get isEnum => enum$ != null;

  Map<String, SchemaOrRefOpenApi> getAllProperties(T Function<T>(String ref) refResolver) {
    final allOfProperties = allOf?.map((e) => e.properties).whereNotNull() ?? [];
    final allOfImplements = allOf
            ?.map((e) => e.ref)
            .whereNotNull()
            .map((e) => refResolver<SchemaOrRefOpenApi>(e).getAllProperties(refResolver)) ??
        [];

    return {
      for (final properties in allOfImplements) ...properties,
      for (final properties in allOfProperties) ...properties,
      ...?properties,
    };
  }

  factory SchemaOrRefOpenApi.fromJson(Map<String, dynamic> map) =>
      _$SchemaOrRefOpenApiFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$SchemaOrRefOpenApiToJson(this);

  @override
  R fold<R>(R Function(String ref) onRef, R Function(SchemaOrRefOpenApi p1) on) {
    if (ref != null) {
      return onRef(ref!);
    } else {
      return on(this);
    }
  }
}
