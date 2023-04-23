// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupMediaOpenApi _$GroupMediaOpenApiFromJson(Map<String, dynamic> json) =>
    GroupMediaOpenApi(
      json: json['application/json'] == null
          ? null
          : MediaOpenApi.fromJson(
              json['application/json'] as Map<String, dynamic>),
      any: json['*/*'] == null
          ? null
          : MediaOpenApi.fromJson(json['*/*'] as Map<String, dynamic>),
      urlEncoded: json['application/x-www-form-urlencoded'] == null
          ? null
          : MediaOpenApi.fromJson(json['application/x-www-form-urlencoded']
              as Map<String, dynamic>),
    );

Map<String, dynamic> _$GroupMediaOpenApiToJson(GroupMediaOpenApi instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('application/json', instance.json);
  writeNotNull('application/x-www-form-urlencoded', instance.urlEncoded);
  writeNotNull('*/*', instance.any);
  return val;
}

MediaOpenApi _$MediaOpenApiFromJson(Map<String, dynamic> json) => MediaOpenApi(
      example: json['example'] as String?,
      examples: json['examples'] as Map<String, dynamic>? ?? const {},
      schema:
          SchemaOrRefOpenApi.fromJson(json['schema'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MediaOpenApiToJson(MediaOpenApi instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('example', instance.example);
  writeNotNull('examples', $nullIfEmpty(instance.examples));
  val['schema'] = instance.schema;
  return val;
}

SchemaOrRefOpenApi _$SchemaOrRefOpenApiFromJson(Map<String, dynamic> json) =>
    SchemaOrRefOpenApi(
      description: json['description'] as String?,
      example: json['example'],
      type: $enumDecodeNullable(_$TypeOpenApiEnumMap, json['type']),
      format: $enumDecodeNullable(_$FormatOpenApiEnumMap, json['format']),
      enum$: (json['enum'] as List<dynamic>?)?.map((e) => e as Object).toList(),
      items: json['items'] == null
          ? null
          : SchemaOrRefOpenApi.fromJson(json['items'] as Map<String, dynamic>),
      ref: json[r'$ref'] as String?,
      properties: (json['properties'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, SchemaOrRefOpenApi.fromJson(e as Map<String, dynamic>)),
      ),
      additionalProperties: json['additionalProperties'] == null
          ? null
          : SchemaOrRefOpenApi.fromJson(
              json['additionalProperties'] as Map<String, dynamic>),
      allOf: (json['allOf'] as List<dynamic>?)
          ?.map((e) => SchemaOrRefOpenApi.fromJson(e as Map<String, dynamic>))
          .toList(),
      required: (json['required'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      nullable: json['nullable'] as bool? ?? false,
      default$: json['default'],
      $original: json[r'$original'],
    );

Map<String, dynamic> _$SchemaOrRefOpenApiToJson(SchemaOrRefOpenApi instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('example', instance.example);
  writeNotNull(r'$ref', instance.ref);
  writeNotNull('type', _$TypeOpenApiEnumMap[instance.type]);
  writeNotNull('format', _$FormatOpenApiEnumMap[instance.format]);
  writeNotNull('enum', instance.enum$);
  writeNotNull('items', instance.items);
  writeNotNull('properties', instance.properties);
  writeNotNull('additionalProperties', instance.additionalProperties);
  writeNotNull('allOf', instance.allOf);
  writeNotNull('required', instance.required);
  writeNotNull('nullable', $nullIfFalse(instance.nullable));
  writeNotNull('default', instance.default$);
  writeNotNull(r'$original', instance.$original);
  return val;
}

const _$TypeOpenApiEnumMap = {
  TypeOpenApi.boolean: 'boolean',
  TypeOpenApi.number: 'number',
  TypeOpenApi.integer: 'integer',
  TypeOpenApi.string: 'string',
  TypeOpenApi.array: 'array',
  TypeOpenApi.object: 'object',
};

const _$FormatOpenApiEnumMap = {
  FormatOpenApi.int32: 'int32',
  FormatOpenApi.int64: 'int64',
  FormatOpenApi.double: 'double',
  FormatOpenApi.float: 'float',
  FormatOpenApi.date: 'date',
  FormatOpenApi.dateTime: 'date-time',
  FormatOpenApi.uuid: 'uuid',
  FormatOpenApi.email: 'email',
  FormatOpenApi.url: 'url',
  FormatOpenApi.uri: 'uri',
  FormatOpenApi.binary: 'binary',
  FormatOpenApi.base64: 'base64',
};
