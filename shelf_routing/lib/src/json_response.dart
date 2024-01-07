import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

/// https://www.rfc-editor.org/rfc/rfc7231#section-6
class JsonResponse<T> extends Response {
  static final _encoder = JsonUtf8Encoder();

  JsonResponse(
    super.statusCode, {
    Object? body,
  }) : super(
          headers: const {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
          body: _encoder.bind(Stream.value(body)),
        );

  JsonResponse.ok(T? body) : this(200, body: body);

  /// The server cannot or will not process the request due to something that is perceived to be a client error
  /// (e.g., malformed request syntax, invalid request message framing, or deceptive request routing).
  JsonResponse.badRequest(Object? body) : this(400, body: body);

  /// Although the HTTP standard specifies "unauthorized", semantically this response means "unauthenticated".
  /// That is, the client must authenticate itself to get the requested response.
  JsonResponse.unauthorized(Object? body) : this(401, body: body);

  /// The client does not have access rights to the content; that is, it is unauthorized,
  /// so the server is refusing to give the requested resource.
  /// Unlike 401 Unauthorized, the client's identity is known to the server.
  JsonResponse.forbidden(Object? body) : this(403, body: body);

  /// The server can not find the requested resource.
  /// This can also mean that the endpoint is valid but the resource itself does not exist.
  /// Servers may also send this response instead of 403 Forbidden to hide the existence of a resource
  /// from an unauthorized client.
  /// This response code is probably the most well known due to its frequent occurrence on the web.
  JsonResponse.notFound(Object? body) : this(404, body: body);

  JsonResponse.conflict(Object? body) : this(409, body: body);
}
