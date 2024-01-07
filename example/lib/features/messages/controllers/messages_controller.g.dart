// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_controller.dart';

// **************************************************************************
// RouterGenerator
// **************************************************************************

Router get _$MessagesControllerRouter => Router()
  ..add('GET', r'/v1/messages', (Request request) async {
    final $ = request.get<MessagesController>();
    return await $.fetchMessages(
      request,
    );
  });
