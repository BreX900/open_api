// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_controller.dart';

// **************************************************************************
// RouterGenerator
// **************************************************************************

Router get _$ChatsControllerRouter => Router()
  ..add('POST', r'/v1/chats', (Request request) async {
    final $ = request.get<ChatsController>();
    return await $.createChatForReport(
      request,
    );
  })
  ..add('GET', r'/v1/chats/<chatId>', (Request request, String chatId) async {
    final $ = request.get<ChatsController>();
    return await $.fetchChat(
      request,
      int.parse(chatId),
    );
  });
