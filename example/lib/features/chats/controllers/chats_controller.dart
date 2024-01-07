import 'package:example/features/chats/dto/chat_create_dto.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_open_api/shelf_open_api.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_routing/shelf_routing.dart';

part 'chats_controller.g.dart';

@RouteGroup('/v1')
class ChatsController {
  static Router get router => _$ChatsControllerRouter;

  const ChatsController();

  @Route.post('/chats')
  @OpenApiRoute(requestBody: ChatCreateDto)
  Future<JsonResponse<void>> createChatForReport(Request request) async {
    // ...

    return JsonResponse.ok(null);
  }

  @Route.get('/chats/<chatId>')
  Future<JsonResponse<void>> fetchChat(Request request, int chatId) async {
    // ...

    return JsonResponse.ok(null);
  }
}
