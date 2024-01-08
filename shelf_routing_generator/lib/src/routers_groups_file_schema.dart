class RoutersGroupsFileSchema {
  static const String extension = '.routers_groups.json';

  final String library;
  final List<RoutesGroupSchema> groups;

  const RoutersGroupsFileSchema({
    required this.library,
    required this.groups,
  });

  factory RoutersGroupsFileSchema.fromJson(Map<String, dynamic> map) {
    return RoutersGroupsFileSchema(
      library: map['library'] as String,
      groups: (map['groups'] as List<dynamic>).map((e) => RoutesGroupSchema.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'library': library,
      'groups': groups,
    };
  }
}

class RoutesGroupSchema {
  final int id;
  final String prefix;
  final String code;

  const RoutesGroupSchema({
    required this.id,
    required this.prefix,
    required this.code,
  });

  factory RoutesGroupSchema.fromJson(Map<String, dynamic> map) {
    return RoutesGroupSchema(
      id: map['id'] as int,
      prefix: map['prefix'] as String,
      code: map['code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prefix': prefix,
      'code': code,
    };
  }
}
