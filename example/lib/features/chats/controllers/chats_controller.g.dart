// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$ChatsControllerRouter(ChatsController service) {
  final router = Router();
  router.add(
    'POST',
    r'/chats',
    service.createChatForReport,
  );
  return router;
}
