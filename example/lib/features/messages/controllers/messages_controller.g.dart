// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_controller.dart';

// **************************************************************************
// RouterGenerator
// **************************************************************************

Router get _$messagesControllerRouter => Router()
  ..add('GET', r'/', (Request request) async {
    $ensureHasHeader(request, 'authorization');
    final $ = request.get<MessagesController>();
    return await $.fetchMessages(
      request,
    );
  });
