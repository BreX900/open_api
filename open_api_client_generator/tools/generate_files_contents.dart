import 'dart:io';

import 'package:path/path.dart';
import 'package:recase/recase.dart';

void main() {
  final root = Directory('./tools/files');

  final variabiles = root.listSync().map((file) {
    final content = File(file.path).readAsStringSync();
    return '  static const String ${basenameWithoutExtension(file.path).camelCase} = r\'\'\'\n'
        '$content'
        '\n\'\'\';';
  });

  File('./lib/src/utils/files_contents.dart')
      .writeAsStringSync('abstract final class FilesContents {\n'
          '${variabiles.join('\n')}'
          '\n}');
}
