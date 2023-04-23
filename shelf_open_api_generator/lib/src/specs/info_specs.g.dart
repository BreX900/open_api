// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_specs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InfoOpenApi _$InfoOpenApiFromJson(Map<String, dynamic> json) => InfoOpenApi(
      title: json['title'] as String,
      description: json['description'] as String?,
      termsOfService: json['termsOfService'] as String?,
      version: json['version'] as String,
    );

Map<String, dynamic> _$InfoOpenApiToJson(InfoOpenApi instance) {
  final val = <String, dynamic>{
    'title': instance.title,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('termsOfService', instance.termsOfService);
  val['version'] = instance.version;
  return val;
}

ServerOpenApi _$ServerOpenApiFromJson(Map<String, dynamic> json) =>
    ServerOpenApi(
      url: json['url'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ServerOpenApiToJson(ServerOpenApi instance) {
  final val = <String, dynamic>{
    'url': instance.url,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  return val;
}

TagOpenApi _$TagOpenApiFromJson(Map<String, dynamic> json) => TagOpenApi(
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$TagOpenApiToJson(TagOpenApi instance) {
  final val = <String, dynamic>{
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  return val;
}
