// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_open_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SecuritySchemeOpenApi _$SecuritySchemeOpenApiFromJson(
        Map<String, dynamic> json) =>
    SecuritySchemeOpenApi(
      type: $enumDecode(_$SecuritySchemeTypeOpenApiEnumMap, json['type']),
      description: json['description'] as String?,
      name: json['name'] as String?,
      in$: $enumDecodeNullable(_$SecuritySchemeInOpenApiEnumMap, json['in']),
      scheme: $enumDecodeNullable(
          _$SecuritySchemeNameOpenApiEnumMap, json['scheme']),
      bearerFormat: json['bearerFormat'] as String?,
      flows: json['flows'] == null
          ? null
          : OAuthFlowsOpenApi.fromJson(json['flows'] as Map<String, dynamic>),
      openIdConnectUrl: json['openIdConnectUrl'] as String?,
    );

Map<String, dynamic> _$SecuritySchemeOpenApiToJson(
    SecuritySchemeOpenApi instance) {
  final val = <String, dynamic>{
    'type': _$SecuritySchemeTypeOpenApiEnumMap[instance.type]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('name', instance.name);
  writeNotNull('in', _$SecuritySchemeInOpenApiEnumMap[instance.in$]);
  writeNotNull('scheme', _$SecuritySchemeNameOpenApiEnumMap[instance.scheme]);
  writeNotNull('bearerFormat', instance.bearerFormat);
  writeNotNull('flows', instance.flows);
  writeNotNull('openIdConnectUrl', instance.openIdConnectUrl);
  return val;
}

const _$SecuritySchemeTypeOpenApiEnumMap = {
  SecuritySchemeTypeOpenApi.apiKey: 'apiKey',
  SecuritySchemeTypeOpenApi.http: 'http',
  SecuritySchemeTypeOpenApi.oauth2: 'oauth2',
  SecuritySchemeTypeOpenApi.openIdConnect: 'openIdConnect',
};

const _$SecuritySchemeInOpenApiEnumMap = {
  SecuritySchemeInOpenApi.query: 'query',
  SecuritySchemeInOpenApi.header: 'header',
  SecuritySchemeInOpenApi.cookie: 'cookie',
};

const _$SecuritySchemeNameOpenApiEnumMap = {
  SecuritySchemeNameOpenApi.basic: 'Basic',
  SecuritySchemeNameOpenApi.bearer: 'Bearer',
  SecuritySchemeNameOpenApi.digest: 'Digest',
  SecuritySchemeNameOpenApi.hoba: 'HOBA',
  SecuritySchemeNameOpenApi.mutual: 'Mutual',
  SecuritySchemeNameOpenApi.negotiate: 'Negotiate',
  SecuritySchemeNameOpenApi.oAuth: 'OAuth',
  SecuritySchemeNameOpenApi.scramSha1: 'SCRAM-SHA-1',
  SecuritySchemeNameOpenApi.scramSha256: 'SCRAM-SHA-256',
  SecuritySchemeNameOpenApi.vapid: 'vapid',
};

OAuthFlowsOpenApi _$OAuthFlowsOpenApiFromJson(Map<String, dynamic> json) =>
    OAuthFlowsOpenApi(
      implicit: json['implicit'] == null
          ? null
          : OAuthFlowOpenApi.fromJson(json['implicit'] as Map<String, dynamic>),
      password: json['password'] == null
          ? null
          : OAuthFlowOpenApi.fromJson(json['password'] as Map<String, dynamic>),
      clientCredentials: json['clientCredentials'] == null
          ? null
          : OAuthFlowOpenApi.fromJson(
              json['clientCredentials'] as Map<String, dynamic>),
      authorizationCode: json['authorizationCode'] == null
          ? null
          : OAuthFlowOpenApi.fromJson(
              json['authorizationCode'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OAuthFlowsOpenApiToJson(OAuthFlowsOpenApi instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('implicit', instance.implicit);
  writeNotNull('password', instance.password);
  writeNotNull('clientCredentials', instance.clientCredentials);
  writeNotNull('authorizationCode', instance.authorizationCode);
  return val;
}

OAuthFlowOpenApi _$OAuthFlowOpenApiFromJson(Map<String, dynamic> json) =>
    OAuthFlowOpenApi(
      authorizationUrl: json['authorizationUrl'] as String,
      tokenUrl: json['tokenUrl'] as String,
      refreshUrl: json['refreshUrl'] as String?,
      scopes: Map<String, String>.from(json['scopes'] as Map),
    );

Map<String, dynamic> _$OAuthFlowOpenApiToJson(OAuthFlowOpenApi instance) {
  final val = <String, dynamic>{
    'authorizationUrl': instance.authorizationUrl,
    'tokenUrl': instance.tokenUrl,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('refreshUrl', instance.refreshUrl);
  val['scopes'] = instance.scopes;
  return val;
}
