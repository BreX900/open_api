import 'package:analyzer/dart/element/element.dart';
import 'package:shelf_routing/shelf_routing.dart';
import 'package:shelf_routing_generator/src/route_handler.dart';
import 'package:shelf_routing_generator/src/routers_groups_file_schema.dart';
import 'package:source_gen/source_gen.dart';

class RouteGroupHandler {
  static const _checker = TypeChecker.fromRuntime(RoutesGroup);

  final String? uid;
  final String? prefix;
  final ClassElement element;
  final List<RouteHandler> routes;

  static RouteGroupHandler? from(ClassElement element) {
    final annotation = ConstantReader(_checker.firstAnnotationOf(element));
    final uid =
        annotation.isNull ? null : RoutesGroupSchema.getUid(annotation.objectValue.type!.element!);
    final prefix = annotation.peek('prefix')?.stringValue;

    final routes = element.methods.map(RouteHandler.from).nonNulls.toList();

    if (uid == null && routes.isEmpty) return null;

    if (prefix != null && !RegExp(r'^\/.*[^/]$').hasMatch(prefix)) {
      throw InvalidGenerationSourceError('"prefix" field must begin and not end with "/".',
          element: element);
    }

    return RouteGroupHandler._(
      uid: uid,
      prefix: prefix,
      element: element,
      routes: routes,
    );
  }

  RouteGroupHandler._({
    required this.uid,
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
