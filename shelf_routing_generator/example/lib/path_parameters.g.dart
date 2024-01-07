// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'path_parameters.dart';

// **************************************************************************
// RouterGenerator
// **************************************************************************

Router get _$PathParametersControllerRouter => Router()
  ..add('GET', r'/<integer>', (Request request, String integer) async {
    final $ = request.get<PathParametersController>();
    return await $.fetchMessages(
      request,
      int.parse(integer),
    );
  })
  ..add('POST', r'/<string>', (Request request, String string) async {
    final $ = request.get<PathParametersController>();
    return await $.createMessage(
      request,
      string,
    );
  })
  ..add('PUT', r'/<decimal>', (Request request, String decimal) async {
    final $ = request.get<PathParametersController>();
    return await $.updateMessage(
      request,
      Decimal.parse(decimal),
    );
  });
