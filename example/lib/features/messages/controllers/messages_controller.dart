import 'package:example/features/messages/dto/message_dto.dart';
import 'package:example/features/messages/dto/message_fetch_dto.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_open_api/shelf_open_api.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_routing/shelf_routing.dart';

part 'messages_controller.g.dart';

@RouteGroup('/v1')
class MessagesController {
  static Router get router => _$MessagesControllerRouter;

  const MessagesController();

  @Route.get('/messages')
  @OpenApiRoute(requestQuery: MessageFetchDto)
  Future<JsonResponse<List<MessageDto>>> fetchMessages(Request request) async {
    // ...

    return JsonResponse.ok(null);
  }
}
