import 'dart:async';

import 'package:code_builder/code_builder.dart';
import 'package:open_api_spec/open_api_spec.dart';

mixin class Plugin {
  const Plugin();

  FutureOr<void> onStart() {}

  OpenApi onSpecification(Map<String, dynamic> specifications, OpenApi openApi) => openApi;

  Class onApiClass(OpenApi openApi, Class spec) => spec;

  Class onDataClass(SchemaOpenApi schema, Class spec) => spec;

  Enum onDataEnum(SchemaOpenApi schema, Enum spec) => spec;

  Library onLibrary(OpenApi openApi, Library spec) => spec;

  FutureOr<void> onFinish() {}
}
