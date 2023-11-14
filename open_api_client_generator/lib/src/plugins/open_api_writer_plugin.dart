import 'dart:io';

import 'package:open_api_client_generator/src/options/options.dart';
import 'package:open_api_client_generator/src/plugins/plugin.dart';
import 'package:open_api_client_generator/src/utils/file_utils.dart';
import 'package:open_api_spec/open_api_spec.dart';
import 'package:recase/recase.dart';

class WriteOpenApiPlugin with Plugin {
  final Options options;
  final String? outputFolder;
  final String? outputFileName;

  WriteOpenApiPlugin({
    required this.options,
    this.outputFolder,
    this.outputFileName,
  });

  late String? _fileName;
  late Map<dynamic, dynamic> _specifications;

  @override
  OpenApi onSpecification(Map<dynamic, dynamic> specifications, OpenApi openApi) {
    _fileName = openApi.info.title.snakeCase;
    _specifications = specifications;

    return openApi;
  }

  @override
  Future<void> onFinish() async {
    await File('${outputFolder ?? options.outputFolder}/${_fileName ?? outputFileName}.yaml')
        .writeAsString(FileUtils.yamlFrom(_specifications));
  }
}
