import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:path/path.dart' as path_;
import 'package:yaml/yaml.dart';

path_.Context get _uri => path_.url;

Future<Map<String, dynamic>> readOpenApi(Uri uri) async {
  if (uri.isScheme('HTTP') || uri.isScheme('HTTPS')) {
    final response = await get(uri);
    final rawOpenApi = response.body;
    return jsonDecode(rawOpenApi);
  } else {
    final path = _uri.fromUri(uri);
    final extension = _uri.extension(path);

    if (const {'.yaml', '.yml'}.contains(extension)) {
      final rawOpenApi = File(path).readAsStringSync();
      return loadYaml(rawOpenApi);
    } else if (extension == '.json') {
      final rawOpenApi = File(path).readAsStringSync();
      return jsonDecode(rawOpenApi);
    } else {
      throw StateError('Not support file $extension');
    }
  }
}

const _sentinelCache = <String, Map<String, dynamic>>{};

Future<Map<String, dynamic>> readOpenApiWithRefs(
  Uri input, {
  Map<String, Map<String, dynamic>>? cache = _sentinelCache,
}) async {
  cache = cache == _sentinelCache ? <String, Map<String, dynamic>>{} : cache;

  final data = await readOpenApi(input);

  final document = await _resolveDocumentRefs(input, data, data, cache: cache);
  return (document as Map<String, dynamic>)..remove('parameters');
}

Future<Object?> _resolveDocumentRefs(
  Uri input,
  Map<String, dynamic> document,
  Object? data, {
  required Map<String, Map<String, dynamic>>? cache,
}) async {
  if (data is List<dynamic>) {
    return await Future.wait<dynamic>(data.map((element) async {
      return await _resolveDocumentRefs(input, document, element, cache: cache);
    }));
  } else if (data is Map<String, dynamic>) {
    final ref = data['\$ref'] as String?;
    if (ref != null) return await readRef(input, document, ref, cache: cache);

    return Map<String, dynamic>.fromEntries(await Future.wait(data.entries.map((_) async {
      final MapEntry(:key, :value) = _;
      return MapEntry(key, await _resolveDocumentRefs(input, document, value, cache: cache));
    })));
  } else {
    return data;
  }
}

Future<Map<String, dynamic>> readRef(
  Uri uri,
  Map<String, dynamic> document,
  String ref, {
  Map<String, Map<String, dynamic>>? cache,
}) async {
  Map<String, dynamic>? pendingData;
  if (cache != null) {
    pendingData = cache[ref];
    if (pendingData != null) return pendingData;
    cache[ref] = pendingData = {};
  }

  final index = ref.indexOf('#');
  final documentRef = index != -1 ? ref.substring(index + 2) : null;
  final fileRef = index != 0 ? ref.substring(0, index == -1 ? null : index) : null;

  if (fileRef != null) {
    final parent = _uri.dirname(uri.path);
    uri = uri.replace(path: _uri.normalize(_uri.join(parent, fileRef)));
    document = await readOpenApiWithRefs(uri);
  }

  var data = document;
  if (documentRef != null) {
    final segments = documentRef.split('/');
    for (final segment in segments) {
      data = data[segment] as Map<String, dynamic>;
    }
    if (!data.containsKey('title')) data = {'title': segments.last, ...data};
  }

  final resolvedData = await _resolveDocumentRefs(uri, document, data, cache: cache);

  if (pendingData != null) {
    pendingData.addAll(resolvedData as Map<String, dynamic>);
    return pendingData;
  } else {
    return resolvedData as Map<String, dynamic>;
  }
}
