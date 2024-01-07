import 'package:analyzer/dart/element/element.dart';
import 'package:shelf_routing/shelf_routing.dart';
import 'package:shelf_routing_generator/src/route_handler.dart';
import 'package:source_gen/source_gen.dart';

class RouteGroupHandler {
  static const _checker = TypeChecker.fromRuntime(RouteGroup);

  final String? prefix;
  final ClassElement element;
  final List<RouteHandler> routes;

  const RouteGroupHandler({
    required this.prefix,
    required this.element,
    required this.routes,
  });

  static RouteGroupHandler? from(ClassElement element) {
    final routes = element.methods.map(RouteHandler.from).nonNulls.toList();
    if (routes.isEmpty) return null;

    final annotation = ConstantReader(_checker.firstAnnotationOf(element));

    return RouteGroupHandler(
      prefix: annotation.peek('path')?.stringValue,
      element: element,
      routes: routes,
    );
  }

  // TODO: Support getters
  // return <ExecutableElement>[
  //         ...element.methods.where(_routeType.hasAnnotationOfExact),
  //         ...element.accessors.where(_routeType.hasAnnotationOfExact)
  //       ]..sort((a, b) => (a.nameOffset).compareTo(b.nameOffset));
  static List<RouteGroupHandler> fromLibrary(LibraryReader library) {
    return library.classes.map(from).nonNulls.toList();
  }
}
