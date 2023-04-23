import 'package:example/features/messages/dto/message_dto.dart';
import 'package:example/features/messages/dto/message_fetch_dto.dart';
import 'package:example/shared/json_response.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_open_api/shelf_open_api.dart';
import 'package:shelf_open_api/shelf_routing.dart';
import 'package:shelf_router/shelf_router.dart';

part 'messages_controller.g.dart';

@Routes(prefix: '/v1')
class MessagesController {
  const MessagesController();

  Router get router => _$MessagesControllerRouter(this);

  @Route.get('/messages')
  @OpenApiRoute(requestQuery: MessageFetchDto)
  Future<JsonResponse<List<MessageDto>>> fetchMessages(Request request) async {
    // ...

    return JsonResponse.ok();
  }
}
