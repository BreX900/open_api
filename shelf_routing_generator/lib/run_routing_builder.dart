import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:shelf_routing/shelf_routing.dart';
import 'package:shelf_routing_generator/src/route_group_handler.dart';
import 'package:shelf_routing_generator/src/utils.dart';
import 'package:source_gen/source_gen.dart';

Builder runRoutingBuilder(BuilderOptions options) {
  return SharedPartBuilder([const GroupsRouterGenerator()], 'routing');
}

class _RoutersRouterHandler {
  static final _checker = TypeChecker.fromRuntime(GenerateRouterFor);

  final PropertyAccessorElement element;
  final Map<DartType, RoutableHandler?> routables;

  static _RoutersRouterHandler? from(PropertyAccessorElement element) {
    if (!element.isGetter) return null;

    final annotation = ConstantReader(_checker.firstAnnotationOf(element));
    if (annotation.isNull) return null;

    return _RoutersRouterHandler._(
      element: element,
      routables: Map.fromEntries(annotation.read('routables').listValue.map((e) {
        final type = e.toTypeValue()!;
        return MapEntry(type, RoutableHandler.from(type.element as ClassElement));
      })),
    );
  }

  const _RoutersRouterHandler._({
    required this.element,
    required this.routables,
  });
}

class GroupsRouterGenerator extends Generator {
  const GroupsRouterGenerator();

  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    final handlers = library.element.units.expand((element) {
      return element.accessors;
    }).map((element) {
      return _RoutersRouterHandler.from(element);
    }).nonNulls;

    return handlers.map((handler) => _generateForHandler(handler, buildStep)).join('\n\n');
  }

  String _generateForHandler(_RoutersRouterHandler handler, BuildStep buildStep) {
    final mountedRouters = handler.routables.entries.map((_) {
      final MapEntry(key: class$, value: handler) = _;
      return '..mount(\'${handler?.prefix ?? '/'}\', ${class$.name}.router)\n';
    }).join();

    return '''
Router get _${codePublicVarName(handler.element.name)} => Router()
  $mountedRouters;''';
  }
}
