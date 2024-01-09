// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// RouterGroupGenerator
// **************************************************************************

import 'package:shelf_router/shelf_router.dart';
import 'routes_group.dart';

Router get $exampleRoutesGroupRouter => Router()
  ..mount('/', RoutesGroupController.router)
  ..mount('/example', RoutesGroupWithPrefixController.router);
