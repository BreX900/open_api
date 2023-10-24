import 'package:json2yaml/json2yaml.dart';

abstract class FileUtils {
  static String yamlFrom(Map<String, dynamic> json) {
    return json2yaml(_jsonToYaml(json));
  }

  static final _badKeys = RegExp(r'[*#]');
  static dynamic _jsonToYaml(dynamic node) {
    if (node is List) {
      return <dynamic>[
        for (final value in node) _jsonToYaml(value),
      ];
    } else if (node is Map<String, dynamic>) {
      return <String, dynamic>{
        for (final e in node.entries) _jsonToYaml(e.key): _jsonToYaml(e.value),
      };
    } else if (node is String) {
      node = node.replaceAll('"', '\\"');
      return _badKeys.hasMatch(node) ? '"$node"' : node;
    }
    return node;
  }
}
