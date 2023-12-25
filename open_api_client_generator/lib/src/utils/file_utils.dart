import 'package:json2yaml/json2yaml.dart';

abstract class FileUtils {
  static String yamlFrom(Map<dynamic, dynamic> json) {
    return json2yaml(_jsonToYaml(json));
  }

  static final _badKeys = RegExp('[*#]');
  static dynamic _jsonToYaml(Object? node) {
    if (node is List) {
      return <dynamic>[
        for (final value in node) _jsonToYaml(value),
      ];
    } else if (node is Map<dynamic, dynamic>) {
      return <String, dynamic>{
        for (final e in node.entries) '${_jsonToYaml(e.key)}': _jsonToYaml(e.value),
      };
    } else if (node is String) {
      node = node.replaceAll('"', r'\"');
      return _badKeys.hasMatch(node) ? '"$node"' : node;
    }
    return node;
  }
}
