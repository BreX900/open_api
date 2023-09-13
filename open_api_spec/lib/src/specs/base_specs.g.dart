// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_specs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenApi _$OpenApiFromJson(Map<String, dynamic> json) => $checkedCreate(
      'OpenApi',
      json,
      ($checkedConvert) {
        final val = OpenApi(
          openapi: $checkedConvert('openapi', (v) => v as String),
          info: $checkedConvert(
              'info', (v) => InfoOpenApi.fromJson(v as Map<String, dynamic>)),
          servers: $checkedConvert(
              'servers',
              (v) =>
                  (v as List<dynamic>?)
                      ?.map((e) =>
                          ServerOpenApi.fromJson(e as Map<String, dynamic>))
                      .toList() ??
                  const []),
          paths: $checkedConvert(
              'paths',
              (v) => (v as Map<String, dynamic>).map(
                    (k, e) => MapEntry(
                        k, ItemPathOpenApi.fromJson(e as Map<String, dynamic>)),
                  )),
          components: $checkedConvert(
              'components',
              (v) => v == null
                  ? const ComponentsOpenApi()
                  : ComponentsOpenApi.fromJson(v as Map<String, dynamic>)),
          tags: $checkedConvert(
              'tags',
              (v) =>
                  (v as List<dynamic>?)
                      ?.map(
                          (e) => TagOpenApi.fromJson(e as Map<String, dynamic>))
                      .toList() ??
                  const []),
        );
        return val;
      },
    );

Map<String, dynamic> _$OpenApiToJson(OpenApi instance) {
  final val = <String, dynamic>{
    'openapi': instance.openapi,
    'info': instance.info.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('servers', $nullIfEmpty(instance.servers));
  val['paths'] = instance.paths.map((k, e) => MapEntry(k, e.toJson()));
  val['components'] = instance.components.toJson();
  val['tags'] = instance.tags.map((e) => e.toJson()).toList();
  return val;
}

ItemPathOpenApi _$ItemPathOpenApiFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ItemPathOpenApi',
      json,
      ($checkedConvert) {
        final val = ItemPathOpenApi(
          summary: $checkedConvert('summary', (v) => v as String?),
          description: $checkedConvert('description', (v) => v as String?),
          get: $checkedConvert(
              'get',
              (v) => v == null
                  ? null
                  : OperationOpenApi.fromJson(v as Map<String, dynamic>)),
          put: $checkedConvert(
              'put',
              (v) => v == null
                  ? null
                  : OperationOpenApi.fromJson(v as Map<String, dynamic>)),
          post: $checkedConvert(
              'post',
              (v) => v == null
                  ? null
                  : OperationOpenApi.fromJson(v as Map<String, dynamic>)),
          delete: $checkedConvert(
              'delete',
              (v) => v == null
                  ? null
                  : OperationOpenApi.fromJson(v as Map<String, dynamic>)),
          head: $checkedConvert(
              'head',
              (v) => v == null
                  ? null
                  : OperationOpenApi.fromJson(v as Map<String, dynamic>)),
          patch: $checkedConvert(
              'patch',
              (v) => v == null
                  ? null
                  : OperationOpenApi.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
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
  writeNotNull('get', instance.get?.toJson());
  writeNotNull('put', instance.put?.toJson());
  writeNotNull('post', instance.post?.toJson());
  writeNotNull('delete', instance.delete?.toJson());
  writeNotNull('head', instance.head?.toJson());
  writeNotNull('patch', instance.patch?.toJson());
  return val;
}

OperationOpenApi _$OperationOpenApiFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'OperationOpenApi',
      json,
      ($checkedConvert) {
        final val = OperationOpenApi(
          tags: $checkedConvert(
              'tags',
              (v) =>
                  (v as List<dynamic>?)?.map((e) => e as String).toList() ??
                  const []),
          summary: $checkedConvert('summary', (v) => v as String?),
          description: $checkedConvert('description', (v) => v as String?),
          operationId: $checkedConvert('operationId', (v) => v as String?),
          parameters: $checkedConvert(
              'parameters',
              (v) =>
                  (v as List<dynamic>?)
                      ?.map((e) =>
                          ParameterOpenApi.fromJson(e as Map<String, dynamic>))
                      .toList() ??
                  const []),
          requestBody: $checkedConvert(
              'requestBody',
              (v) => v == null
                  ? null
                  : RequestBodyOpenApi.fromJson(v as Map<String, dynamic>)),
          responses: $checkedConvert(
              'responses',
              (v) => (v as Map<String, dynamic>).map(
                    (k, e) => MapEntry(int.parse(k),
                        ResponseOpenApi.fromJson(e as Map<String, dynamic>)),
                  )),
          deprecated: $checkedConvert('deprecated', (v) => v as bool? ?? false),
          security: $checkedConvert(
              'security',
              (v) =>
                  (v as Map<String, dynamic>?)?.map(
                    (k, e) => MapEntry(k,
                        (e as List<dynamic>).map((e) => e as String).toList()),
                  ) ??
                  const {}),
          servers: $checkedConvert(
              'servers',
              (v) =>
                  (v as List<dynamic>?)
                      ?.map((e) =>
                          ServerOpenApi.fromJson(e as Map<String, dynamic>))
                      .toList() ??
                  const []),
        );
        return val;
      },
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
  writeNotNull('requestBody', instance.requestBody?.toJson());
  val['responses'] =
      instance.responses.map((k, e) => MapEntry(k.toString(), e.toJson()));
  writeNotNull('deprecated', $nullIfFalse(instance.deprecated));
  writeNotNull('security', $nullIfEmpty(instance.security));
  writeNotNull('servers', $nullIfEmpty(instance.servers));
  return val;
}

ParameterOpenApi _$ParameterOpenApiFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ParameterOpenApi',
      json,
      ($checkedConvert) {
        final val = ParameterOpenApi(
          description: $checkedConvert('description', (v) => v as String?),
          example: $checkedConvert('example', (v) => v),
          name: $checkedConvert('name', (v) => v as String),
          in$: $checkedConvert(
              'in', (v) => $enumDecode(_$ParameterInOpenApiEnumMap, v)),
          required: $checkedConvert('required', (v) => v as bool? ?? false),
          deprecated: $checkedConvert('deprecated', (v) => v as bool? ?? false),
          style: $checkedConvert('style', (v) => v as String?),
          explode: $checkedConvert('explode', (v) => v as bool?),
          schema: $checkedConvert(
              'schema',
              (v) => v == null
                  ? null
                  : SchemaOpenApi.fromJson(v as Map<String, dynamic>)),
          examples: $checkedConvert(
              'examples', (v) => v as Map<String, dynamic>? ?? const {}),
        );
        return val;
      },
      fieldKeyMap: const {r'in$': 'in'},
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
  writeNotNull('style', instance.style);
  writeNotNull('explode', instance.explode);
  writeNotNull('schema', instance.schema?.toJson());
  return val;
}

const _$ParameterInOpenApiEnumMap = {
  ParameterInOpenApi.path: 'path',
  ParameterInOpenApi.query: 'query',
  ParameterInOpenApi.header: 'header',
  ParameterInOpenApi.cookie: 'cookie',
};

RequestBodyOpenApi _$RequestBodyOpenApiFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RequestBodyOpenApi',
      json,
      ($checkedConvert) {
        final val = RequestBodyOpenApi(
          description: $checkedConvert('description', (v) => v as String?),
          required: $checkedConvert('required', (v) => v as bool? ?? false),
          content: $checkedConvert('content',
              (v) => GroupMediaOpenApi.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
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
  val['content'] = instance.content.toJson();
  return val;
}

ResponseOpenApi _$ResponseOpenApiFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ResponseOpenApi',
      json,
      ($checkedConvert) {
        final val = ResponseOpenApi(
          description: $checkedConvert('description', (v) => v as String),
          headers: $checkedConvert(
              'headers', (v) => v as Map<String, dynamic>? ?? const {}),
          content: $checkedConvert(
              'content',
              (v) => v == null
                  ? null
                  : GroupMediaOpenApi.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
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
  writeNotNull('content', instance.content?.toJson());
  return val;
}

ComponentsOpenApi _$ComponentsOpenApiFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ComponentsOpenApi',
      json,
      ($checkedConvert) {
        final val = ComponentsOpenApi(
          schemas: $checkedConvert(
              'schemas',
              (v) =>
                  (v as Map<String, dynamic>?)?.map(
                    (k, e) => MapEntry(
                        k, SchemaOpenApi.fromJson(e as Map<String, dynamic>)),
                  ) ??
                  const {}),
          responses: $checkedConvert(
              'responses',
              (v) =>
                  (v as Map<String, dynamic>?)?.map(
                    (k, e) => MapEntry(
                        k, ResponseOpenApi.fromJson(e as Map<String, dynamic>)),
                  ) ??
                  const {}),
          parameters: $checkedConvert(
              'parameters',
              (v) =>
                  (v as Map<String, dynamic>?)?.map(
                    (k, e) => MapEntry(k,
                        ParameterOpenApi.fromJson(e as Map<String, dynamic>)),
                  ) ??
                  const {}),
          requestBodies: $checkedConvert(
              'requestBodies', (v) => v as Map<String, dynamic>? ?? const {}),
          securitySchemes: $checkedConvert(
              'securitySchemes',
              (v) =>
                  (v as Map<String, dynamic>?)?.map(
                    (k, e) => MapEntry(
                        k,
                        SecuritySchemeOpenApi.fromJson(
                            e as Map<String, dynamic>)),
                  ) ??
                  const {}),
        );
        return val;
      },
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
