// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// RouterGenerator
// **************************************************************************

Router get _$responsesControllerRouter => Router()
  ..add('GET', r' /', (Request request) async {
    final $ = request.get<ResponsesController>();
    return $.sync(
      request,
    );
  })
  ..add('POST', r' /', (Request request) async {
    final $ = request.get<ResponsesController>();
    return await $.async(
      request,
    );
  });