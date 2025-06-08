import 'package:shelf_router/shelf_router.dart';
import 'package:example/features/messages/controllers/messages_controller.dart';
import 'package:example/features/chats/controllers/chats_controller.dart';

Router get $controllersRouter => Router()
  ..mount('/v1', MessagesController().router)
  ..mount('/v1', ChatsController().router);
