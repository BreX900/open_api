// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// RoutingGenerator
// **************************************************************************

import 'package:shelf_routing/shelf_routing.dart';
import 'package:example/features/path_parameters.dart';
import 'package:example/features/messages/controllers/messages_controller.dart';
import 'package:example/features/query_parameters.dart';
import 'package:example/features/chats/controllers/chats_controller.dart';

Router get $mainRouter => Router()
  ..mount('/path-parameters', PathParametersController.router)
  ..mount('/v1', MessagesController.router)
  ..mount('/', QueryParametersController.router)
  ..mount('/v1', ChatsController.router);
