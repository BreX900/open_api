import 'package:example/features/chats/dto/chat_create_dto.dart';
import 'package:example/shared/api_route_group.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_open_api/shelf_open_api.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_routing/shelf_routing.dart';

part 'chats_controller.g.dart';

@ApiRouterGroup(prefix: '/chats')
class ChatsController {
  static Router get router => _$chatsControllerRouter;

  const ChatsController();

  @Route.get('/')
  @OpenApiRoute(requestBody: ChatCreateDto)
  Future<JsonResponse<void>> createChatForReport(Request request) async {
    // ...

    return JsonResponse.ok('/');
  }

  @Route.get('/<chatId>')
  Future<JsonResponse<void>> fetchChat(Request request, int chatId) async {
    // ...

    return JsonResponse.ok('/<chatId>');
  }
}
