import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

class RoutersGroupsAssetSchema {
  static const String extension = '.routers_groups.json';

  final AssetId id;
  final List<RoutesGroupSchema> groups;

  const RoutersGroupsAssetSchema({
    required this.id,
    required this.groups,
  });

  RoutersGroupsAssetSchema copyForGroup(String id) {
    return RoutersGroupsAssetSchema(
      id: this.id,
      groups: groups.where((e) => e.uid == id).toList(),
    );
  }

  factory RoutersGroupsAssetSchema.fromJson(Map<String, dynamic> map) {
    return RoutersGroupsAssetSchema(
      id: AssetId.deserialize(map['id'] as List<dynamic>),
      groups: (map['groups'] as List<dynamic>).map((e) => RoutesGroupSchema.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.serialize(),
      'groups': groups,
    };
  }
}

class RoutesGroupSchema {
  final String uid;
  final String prefix;
  final String code;

  const RoutesGroupSchema({
    required this.uid,
    required this.prefix,
    required this.code,
  });

  static String getUid(Element element) => '${element.library!.identifier}:${element.name!}';

  factory RoutesGroupSchema.fromJson(Map<String, dynamic> map) {
    return RoutesGroupSchema(
      uid: map['uid'] as String,
      prefix: map['prefix'] as String,
      code: map['code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'prefix': prefix,
      'code': code,
    };
  }
}
