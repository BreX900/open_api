// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'path_parameters.dart';

// **************************************************************************
// RouterGenerator
// **************************************************************************

Router get _$PathParametersControllerRouter => Router()
  ..add('GET', r'/path-parameters/<intParameter>',
      (Request request, String intParameter) async {
    final $ = request.get<PathParametersController>();
    return await $.fetchMessages(
      request,
      int.parse(intParameter),
    );
  })
  ..add('POST', r'/path-parameters/<stringParameter>',
      (Request request, String stringParameter) async {
    final $ = request.get<PathParametersController>();
    return await $.createMessage(
      request,
      stringParameter,
    );
  })
  ..add('PUT', r'/path-parameters/<decimalParameter>',
      (Request request, String decimalParameter) async {
    final $ = request.get<PathParametersController>();
    return await $.updateMessage(
      request,
      int.parse(decimalParameter),
    );
  });
