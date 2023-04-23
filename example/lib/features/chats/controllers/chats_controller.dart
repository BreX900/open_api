import 'package:example/features/chats/dto/chat_create_dto.dart';
import 'package:example/shared/json_response.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_open_api/shelf_open_api.dart';
import 'package:shelf_open_api/shelf_routing.dart';
import 'package:shelf_router/shelf_router.dart';

part 'chats_controller.g.dart';

@Routes(prefix: '/v1')
class ChatsController {
  const ChatsController();

  Router get router => _$ChatsControllerRouter(this);

  @Route.post('/chats')
  @OpenApiRoute(requestBody: ChatCreateDto)
  Future<JsonResponse<void>> createChatForReport(Request request) async {
    // ...

    return JsonResponse.ok();
  }
}
