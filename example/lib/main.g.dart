// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// RoutingGenerator
// **************************************************************************

Router _$ApiControllerRouter(ApiController $) => Router()
  ..mount(r'/v1', $.chats.call)
  ..mount(r'/v1', $.messages.call);
