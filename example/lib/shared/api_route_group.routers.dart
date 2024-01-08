// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// RouterGroupGenerator
// **************************************************************************

import 'package:shelf_router/shelf_router.dart';
import 'package:example/features/messages/controllers/messages_controller.dart';
import 'package:example/features/chats/controllers/chats_controller.dart';

Router get $apiRouteGroupRouter => Router()
  ..mount('/v1/messages/v2', MessagesController.router)
  ..mount('/v1/chats', ChatsController.router);
