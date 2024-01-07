import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_routing/shelf_routing.dart';

T $parsePathParameter<T>(String value, T Function(String vl) parser) {
  try {
    return parser(value);
  } catch (error, stackTrace) {
    throw BadRequestException.path(error, stackTrace);
  }
}

T $parseQueryParameters<T>(Request request, String name, T Function(List<String> vls) parser) {
  try {
    return parser(request.url.queryParametersAll[name] ?? const <String>[]);
  } catch (error, stackTrace) {
    throw BadRequestException.queryParameter(error, stackTrace, name);
  }
}

// T $parseHeaders<T>(Request request, String name, T Function(List<String> vls) parser) {
//   try {
//     return parser(request.headersAll[name] ?? const <String>[]);
//   } catch (error, stackTrace) {
//     throw BadRequestException.header(error, stackTrace, name);
//   }
// }

void $ensureHasHeader(Request request, String name) {
  try {
    ArgumentError.checkNotNull(request.headersAll[name], name);
  } catch (error, stackTrace) {
    throw BadRequestException.header(error, stackTrace, name);
  }
}

Future<T> $readBodyAs<T>(Request request, T Function(Map<String, dynamic> data) converter) async {
  try {
    final data = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
    return converter(data);
  } catch (error, stackTrace) {
    throw BadRequestException.body(error, stackTrace);
  }
}
