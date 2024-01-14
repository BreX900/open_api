import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

class RouterGroupsAssetSchema {
  static const String extension = '.router_groups.json';

  final AssetId id;
  final List<RouterGroupSchema> groups;

  const RouterGroupsAssetSchema({
    required this.id,
    required this.groups,
  });

  RouterGroupsAssetSchema copyForGroup(String id) {
    return RouterGroupsAssetSchema(
      id: this.id,
      groups: groups.where((e) => e.uid == id).toList(),
    );
  }

  factory RouterGroupsAssetSchema.fromJson(Map<String, dynamic> map) {
    return RouterGroupsAssetSchema(
      id: AssetId.deserialize(map['id'] as List<dynamic>),
      groups: (map['groups'] as List<dynamic>).map((e) => RouterGroupSchema.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.serialize(),
      'groups': groups,
    };
  }
}

class RouterGroupSchema {
  final String uid;
  final String prefix;
  final String code;

  const RouterGroupSchema({
    required this.uid,
    required this.prefix,
    required this.code,
  });

  static String getUid(Element element) => '${element.library!.identifier}:${element.name!}';

  factory RouterGroupSchema.fromJson(Map<String, dynamic> map) {
    return RouterGroupSchema(
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
