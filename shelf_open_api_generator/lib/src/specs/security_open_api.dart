import 'package:json_annotation/json_annotation.dart';
import 'package:shelf_open_api_generator/src/specs/ref_or_specs.dart';
import 'package:shelf_open_api_generator/src/specs/specs_serialization.dart';

part 'security_open_api.g.dart';

enum SecuritySchemeTypeOpenApi { apiKey, http, oauth2, openIdConnect }

enum SecuritySchemeInOpenApi { query, header, cookie }

/// https://www.iana.org/assignments/http-authschemes/http-authschemes.xhtml
enum SecuritySchemeNameOpenApi {
  @JsonValue('Basic')
  basic,
  @JsonValue('Bearer')
  bearer,
  @JsonValue('Digest')
  digest,
  @JsonValue('HOBA')
  hoba,
  @JsonValue('Mutual')
  mutual,
  @JsonValue('Negotiate')
  negotiate,
  @JsonValue('OAuth')
  oAuth,
  @JsonValue('SCRAM-SHA-1')
  scramSha1,
  @JsonValue('SCRAM-SHA-256')
  scramSha256,
  @JsonValue('vapid')
  vapid
}

/// Version: 3.0.3
@SpecsSerializable()
class SecuritySchemeOpenApi with RefOrOpenApi<SecuritySchemeOpenApi> {
  final SecuritySchemeTypeOpenApi type;
  final String? description;
  final String? name;
  @JsonKey(name: 'in')
  final SecuritySchemeInOpenApi? in$;
  final SecuritySchemeNameOpenApi? scheme;
  final String? bearerFormat;
  final OAuthFlowsOpenApi? flows;
  final String? openIdConnectUrl;

  const SecuritySchemeOpenApi({
    required this.type,
    this.description,
    this.name,
    this.in$,
    this.scheme,
    this.bearerFormat,
    this.flows,
    this.openIdConnectUrl,
  });

  @override
  R fold<R>(R Function(String ref) onRef, R Function(SecuritySchemeOpenApi p1) on) {
    return on(this);
  }

  factory SecuritySchemeOpenApi.fromJson(Map<String, dynamic> map) =>
      _$SecuritySchemeOpenApiFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$SecuritySchemeOpenApiToJson(this);

  @override
  String? get ref => null;
}

/// Version: 3.0.3
@SpecsSerializable()
class OAuthFlowsOpenApi {
  final OAuthFlowOpenApi? implicit;
  final OAuthFlowOpenApi? password;
  final OAuthFlowOpenApi? clientCredentials;
  final OAuthFlowOpenApi? authorizationCode;

  const OAuthFlowsOpenApi({
    this.implicit,
    this.password,
    this.clientCredentials,
    this.authorizationCode,
  });

  factory OAuthFlowsOpenApi.fromJson(Map<String, dynamic> map) => _$OAuthFlowsOpenApiFromJson(map);
  Map<String, dynamic> toJson() => _$OAuthFlowsOpenApiToJson(this);
}

/// Version: 3.0.3
@SpecsSerializable()
class OAuthFlowOpenApi {
  final String authorizationUrl;
  final String tokenUrl;
  final String? refreshUrl;
  final Map<String, String> scopes;

  const OAuthFlowOpenApi({
    required this.authorizationUrl,
    required this.tokenUrl,
    this.refreshUrl,
    required this.scopes,
  });

  factory OAuthFlowOpenApi.fromJson(Map<String, dynamic> map) => _$OAuthFlowOpenApiFromJson(map);
  Map<String, dynamic> toJson() => _$OAuthFlowOpenApiToJson(this);
}
