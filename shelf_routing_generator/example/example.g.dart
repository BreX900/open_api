// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// RouterGenerator
// **************************************************************************

Router get _$userControllerRouter => Router()
  ..add('GET', r'/users', (Request request) async {
    final $ = request.get<UserController>();
    final $data = await $.listUsers(
      request,
      query: $parseQueryParameters(
          request, 'query', (vls) => vls.isNotEmpty ? vls.single : null),
    );
    return JsonResponse.ok($data);
  })
  ..add('GET', r'/users/<userId>', (Request request, String userId) async {
    final $ = request.get<UserController>();
    return await $.fetchUser(
      request,
      int.parse(userId),
    );
  })
  ..add('POST', r'/users', (Request request) async {
    final $ = request.get<UserController>();
    return await $.createUser(
      request,
      await $readBodyAs(request, User.fromJson),
    );
  });
