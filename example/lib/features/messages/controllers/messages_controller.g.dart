// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_controller.dart';

// **************************************************************************
// RoutingGenerator
// **************************************************************************

Router _$MessagesControllerRouter(MessagesController $) => Router()
  ..add('GET', r'/messages', (Request request) async {
    return await $.fetchMessages(request);
  })
  ..add('GET', r'/messages/<messageId>', (
    Request request,
    String messageId,
  ) async {
    return await $.fetchMessage(request, int.parse(messageId));
  });
