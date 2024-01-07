class RoutersGroupsFileSchema {
  static const String extension = '.routers_groups.json';

  final String library;
  final Map<String, List<RouterGroupSchema>> groups;

  const RoutersGroupsFileSchema({
    required this.library,
    required this.groups,
  });

  factory RoutersGroupsFileSchema.fromJson(Map<String, dynamic> map) {
    return RoutersGroupsFileSchema(
      library: map['library'] as String,
      groups: (map['groups'] as Map<String, dynamic>).map((name, groups) {
        return MapEntry(name, (groups as List).map((e) => RouterGroupSchema.fromJson(e)).toList());
      }),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'library': library,
      'groups': groups,
    };
  }
}

class RouterGroupSchema {
  final String prefix;
  final String code;

  const RouterGroupSchema({
    required this.prefix,
    required this.code,
  });

  factory RouterGroupSchema.fromJson(Map<String, dynamic> map) {
    return RouterGroupSchema(
      prefix: map['prefix'] as String,
      code: map['code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prefix': prefix,
      'code': code,
    };
  }
}
