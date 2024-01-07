// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_controller.dart';

// **************************************************************************
// RouterGenerator
// **************************************************************************

Router get _$ChatsControllerRouter => Router()
  ..add('GET', r' /', (Request request) async {
    final $ = request.get<ChatsController>();
    return await $.createChatForReport(
      request,
    );
  })
  ..add('GET', r' /<chatId>', (Request request, String chatId) async {
    final $ = request.get<ChatsController>();
    return await $.fetchChat(
      request,
      int.parse(chatId),
    );
  });
