// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_controller.dart';

// **************************************************************************
// RoutingGenerator
// **************************************************************************

Router _$ChatsControllerRouter(ChatsController $) => Router()
  ..add('POST', r'/chats', (Request request) async {
    return await $.createChatForReport(request);
  })
  ..add('POST', r'/chats', (Request request) async {
    return await $.createChatForReportV2(
      request,
      await $parseBodyAs(
        request,
        (data) => ChatCreateDto.fromJson(data! as Map<String, dynamic>),
      ),
    );
  });
