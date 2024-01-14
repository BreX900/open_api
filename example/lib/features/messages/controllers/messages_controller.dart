import 'package:example/features/messages/dto/message_dto.dart';
import 'package:example/features/messages/dto/message_fetch_dto.dart';
import 'package:example/shared/api_route_group.dart';
import 'package:example/shared/authorization_header.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_open_api/shelf_open_api.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_routing/shelf_routing.dart';

part 'messages_controller.g.dart';

@ApiRouterGroup(prefix: '/messages/v2')
class MessagesController {
  static Router get router => _$messagesControllerRouter;

  const MessagesController();

  @Route.get('/')
  @RouteHeaders.authorize()
  @OpenApiRoute(requestQuery: MessageFetchDto)
  Future<JsonResponse<List<MessageDto>>> fetchMessages(Request request) async {
    // ...

    return JsonResponse.ok(null);
  }
}
