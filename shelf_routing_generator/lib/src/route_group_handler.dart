import 'package:analyzer/dart/element/element.dart';
import 'package:shelf_routing/shelf_routing.dart';
import 'package:shelf_routing_generator/src/route_handler.dart';
import 'package:source_gen/source_gen.dart';

class RouteGroupHandler {
  static const _checker = TypeChecker.fromRuntime(RouteGroup);

  final String? name;
  final String? prefix;
  final ClassElement element;
  final List<RouteHandler> routes;

  static RouteGroupHandler? from(ClassElement element) {
    final annotation = ConstantReader(_checker.firstAnnotationOf(element));
    final name = annotation.peek('name')?.stringValue;
    final prefix = annotation.peek('prefix')?.stringValue;

    final routes = element.methods.map(RouteHandler.from).nonNulls.toList();

    if (name == null && routes.isEmpty) return null;

    if (prefix != null && !RegExp(r'^\/.*[^/]$').hasMatch(prefix)) {
      throw InvalidGenerationSourceError('"prefix" field must begin and not end with "/".',
          element: element);
    }

    return RouteGroupHandler._(
      name: name,
      prefix: prefix,
      element: element,
      routes: routes,
    );
  }

  RouteGroupHandler._({
    required this.name,
    required this.prefix,
    required this.element,
    required this.routes,
  });

  // TODO: Support getters
  // return <ExecutableElement>[
  //         ...element.methods.where(_routeType.hasAnnotationOfExact),
  //         ...element.accessors.where(_routeType.hasAnnotationOfExact)
  //       ]..sort((a, b) => (a.nameOffset).compareTo(b.nameOffset));
  static List<RouteGroupHandler> fromLibrary(LibraryReader library) {
    return library.classes.map(from).nonNulls.toList();
  }
}
