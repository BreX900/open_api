import 'package:diacritic/diacritic.dart';
import 'package:meta/meta.dart';
import 'package:open_api_client_generator/src/options/options.dart';
import 'package:recase/recase.dart';

class Codecs {
  const Codecs();

  @protected
  String encodeType(String name) => name;

  static final _keywords = {
    'else',
    'enum',
    'in',
    'assert',
    'super',
    'extends',
    'is',
    'switch',
    'break',
    'this',
    'case',
    'throw',
    'catch',
    'false',
    'new',
    'true',
    'class',
    'final',
    'null',
    'try',
    'const',
    'finally',
    'continue',
    'for',
    'var',
    'void',
    'default',
    'while',
    'rethrow',
    'with',
    'do',
    'if',
    'return',
  };

  @protected
  String encodeFieldName(String str) {
    str = str.replaceAll('@', '');
    return _keywords.contains(str) ? '$str\$' : str;
  }

  String encodeDartValue(Object value) {
    if (value is String) return "'${value.replaceAll('\$', '\\\$')}'";
    return '$value';
  }

  String encodeEnumValue(Object value) => value is String ? encodeFieldName(value) : 'vl$value';
}

class ApiCodecs extends Codecs {
  final Options options;

  ApiCodecs({required this.options});

  @override
  String encodeType(String name) =>
      '${removeDiacritics(super.encodeType(name)).pascalCase}${options.dataClassesPostfix ?? ''}';

  @override
  String encodeFieldName(String str) => super.encodeFieldName(removeDiacritics(str).camelCase);
}
