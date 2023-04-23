// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_specs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenApi _$OpenApiFromJson(Map<String, dynamic> json) => OpenApi(
      openapi: json['openapi'] as String,
      info: InfoOpenApi.fromJson(json['info'] as Map<String, dynamic>),
      servers: (json['servers'] as List<dynamic>?)
              ?.map((e) => ServerOpenApi.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      paths: (json['paths'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, ItemPathOpenApi.fromJson(e as Map<String, dynamic>)),
      ),
      components: ComponentsOpenApi.fromJson(
          json['components'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => TagOpenApi.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$OpenApiToJson(OpenApi instance) {
  final val = <String, dynamic>{
    'openapi': instance.openapi,
    'info': instance.info,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('servers', $nullIfEmpty(instance.servers));
  val['paths'] = instance.paths;
  val['components'] = instance.components;
  val['tags'] = instance.tags;
  return val;
}

ItemPathOpenApi _$ItemPathOpenApiFromJson(Map<String, dynamic> json) =>
    ItemPathOpenApi(
      summary: json['summary'] as String?,
      description: json['description'] as String?,
      get: json['get'] == null
          ? null
          : OperationOpenApi.fromJson(json['get'] as Map<String, dynamic>),
      put: json['put'] == null
          ? null
          : OperationOpenApi.fromJson(json['put'] as Map<String, dynamic>),
      post: json['post'] == null
          ? null
          : OperationOpenApi.fromJson(json['post'] as Map<String, dynamic>),
      delete: json['delete'] == null
          ? null
          : OperationOpenApi.fromJson(json['delete'] as Map<String, dynamic>),
      head: json['head'] == null
          ? null
          : OperationOpenApi.fromJson(json['head'] as Map<String, dynamic>),
      patch: json['patch'] == null
          ? null
          : OperationOpenApi.fromJson(json['patch'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ItemPathOpenApiToJson(ItemPathOpenApi instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('summary', instance.summary);
  writeNotNull('description', instance.description);
  writeNotNull('get', instance.get);
  writeNotNull('put', instance.put);
  writeNotNull('post', instance.post);
  writeNotNull('delete', instance.delete);
  writeNotNull('head', instance.head);
  writeNotNull('patch', instance.patch);
  return val;
}

OperationOpenApi _$OperationOpenApiFromJson(Map<String, dynamic> json) =>
    OperationOpenApi(
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      summary: json['summary'] as String?,
      description: json['description'] as String?,
      operationId: json['operationId'] as String?,
      parameters: (json['parameters'] as List<dynamic>?)
              ?.map((e) => const RefOrParamOpenApiConverter()
                  .fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      requestBody: json['requestBody'] == null
          ? null
          : RequestBodyOpenApi.fromJson(
              json['requestBody'] as Map<String, dynamic>),
      responses: (json['responses'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            int.parse(k), ResponseOpenApi.fromJson(e as Map<String, dynamic>)),
      ),
      deprecated: json['deprecated'] as bool? ?? false,
      security: (json['security'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, (e as List<dynamic>).map((e) => e as String).toList()),
          ) ??
          const {},
    );

Map<String, dynamic> _$OperationOpenApiToJson(OperationOpenApi instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('tags', $nullIfEmpty(instance.tags));
  writeNotNull('summary', instance.summary);
  writeNotNull('description', instance.description);
  writeNotNull('operationId', instance.operationId);
  writeNotNull('parameters', $nullIfEmpty(instance.parameters));
  writeNotNull('requestBody', instance.requestBody);
  val['responses'] =
      instance.responses.map((k, e) => MapEntry(k.toString(), e));
  writeNotNull('deprecated', $nullIfFalse(instance.deprecated));
  writeNotNull('security', $nullIfEmpty(instance.security));
  return val;
}

ParameterOpenApi _$ParameterOpenApiFromJson(Map<String, dynamic> json) =>
    ParameterOpenApi(
      description: json['description'] as String?,
      example: json['example'],
      name: json['name'] as String,
      in$: $enumDecode(_$ParameterInOpenApiEnumMap, json['in']),
      required: json['required'] as bool? ?? false,
      deprecated: json['deprecated'] as bool? ?? false,
      schema: json['schema'] == null
          ? null
          : SchemaOrRefOpenApi.fromJson(json['schema'] as Map<String, dynamic>),
      examples: json['examples'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$ParameterOpenApiToJson(ParameterOpenApi instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('example', instance.example);
  writeNotNull('examples', $nullIfEmpty(instance.examples));
  val['name'] = instance.name;
  val['in'] = _$ParameterInOpenApiEnumMap[instance.in$]!;
  val['required'] = instance.required;
  writeNotNull('deprecated', $nullIfFalse(instance.deprecated));
  writeNotNull('schema', instance.schema);
  return val;
}

const _$ParameterInOpenApiEnumMap = {
  ParameterInOpenApi.path: 'path',
  ParameterInOpenApi.query: 'query',
  ParameterInOpenApi.header: 'header',
  ParameterInOpenApi.cookie: 'cookie',
};

RequestBodyOpenApi _$RequestBodyOpenApiFromJson(Map<String, dynamic> json) =>
    RequestBodyOpenApi(
      description: json['description'] as String?,
      required: json['required'] as bool? ?? false,
      content:
          GroupMediaOpenApi.fromJson(json['content'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RequestBodyOpenApiToJson(RequestBodyOpenApi instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  val['required'] = instance.required;
  val['content'] = instance.content;
  return val;
}

ResponseOpenApi _$ResponseOpenApiFromJson(Map<String, dynamic> json) =>
    ResponseOpenApi(
      description: json['description'] as String,
      headers: json['headers'] as Map<String, dynamic>? ?? const {},
      content: json['content'] == null
          ? null
          : GroupMediaOpenApi.fromJson(json['content'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResponseOpenApiToJson(ResponseOpenApi instance) {
  final val = <String, dynamic>{
    'description': instance.description,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('headers', $nullIfEmpty(instance.headers));
  writeNotNull('content', instance.content);
  return val;
}

ComponentsOpenApi _$ComponentsOpenApiFromJson(Map<String, dynamic> json) =>
    ComponentsOpenApi(
      schemas: (json['schemas'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, SchemaOrRefOpenApi.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      responses: (json['responses'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, ResponseOpenApi.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      parameters: (json['parameters'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, ParameterOpenApi.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      requestBodies: json['requestBodies'] as Map<String, dynamic>? ?? const {},
      securitySchemes: (json['securitySchemes'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k,
                const RefOrSecuritySchemeOpenApiConverter()
                    .fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$ComponentsOpenApiToJson(ComponentsOpenApi instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('schemas', $nullIfEmpty(instance.schemas));
  writeNotNull('responses', $nullIfEmpty(instance.responses));
  writeNotNull('parameters', $nullIfEmpty(instance.parameters));
  writeNotNull('requestBodies', $nullIfEmpty(instance.requestBodies));
  writeNotNull('securitySchemes', $nullIfEmpty(instance.securitySchemes));
  return val;
}
