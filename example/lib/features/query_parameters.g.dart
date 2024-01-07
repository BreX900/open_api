// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_parameters.dart';

// **************************************************************************
// RouterGenerator
// **************************************************************************

Router get _$QueryParametersControllerRouter => Router()
  ..add('GET', r'/messages', (Request request) async {
    final $ = request.get<QueryParametersController>();
    return await $.fetchMessages(
      request,
      userId: $parseQueryParameters(
          request, 'user-id', (vls) => int.parse(vls.single)),
      pageSize: $parseQueryParameters(request, 'page-size',
          (vls) => vls.isNotEmpty ? int.parse(vls.single) : null),
      pageCount: $parseQueryParameters(request, 'page-count',
          (vls) => vls.isNotEmpty ? int.parse(vls.single) : null),
      query: $parseQueryParameters(
          request, 'query', (vls) => vls.isNotEmpty ? vls.single : null),
      keywords: $parseQueryParameters(request, 'keywords', (vls) => vls),
    );
  });
