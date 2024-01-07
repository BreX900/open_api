import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_routing_generator/src/utils.dart';
import 'package:source_gen/source_gen.dart';

enum RouteReturnsType { response, json, nothing }

class RouteHandler {
  static const TypeChecker _checker = TypeChecker.fromRuntime(Route);

  final String method;
  final String path;
  final MethodElement element;

  final ParameterElement? bodyParameter;
  final bool hasRequest;
  final List<ParameterElement> pathParameters;
  final List<ParameterElement> headerParameters;
  final List<ParameterElement> queryParameters;
  final RouteReturnsType returns;

  RouteHandler._({
    required this.method,
    required this.path,
    required this.element,
    required this.bodyParameter,
    required this.hasRequest,
    required this.pathParameters,
    required this.headerParameters,
    required this.queryParameters,
    required this.returns,
  }) {
    _validate();
  }

  static RouteHandler? from(MethodElement element) {
    final annotation = ConstantReader(_checker.firstAnnotationOf(element));
    if (annotation.isNull) return null;

    final verb = annotation.read('verb').stringValue;
    final route = annotation.read('route').stringValue;

    print(_checker.firstAnnotationOf(element));
    print(_checker.firstAnnotationOf(element)?.type);
    print(element.metadata.map((e) => (e.element as ConstructorElement).isSynthetic).toList());

    // final headers = RouteHeaderHandler.from(element);

    final pathParams = RegExp(r'\/<(\w+)>').allMatches(route).map((e) => e.group(1)!).toList();

    ParameterElement? bodyParameter;
    final pathParameters = <ParameterElement>[];

    final parametersIterator = element.parameters.where((e) => e.isPositional).iterator;

    if (!parametersIterator.moveNext() ||
        !requestChecker.isAssignableFromType(parametersIterator.current.type)) {
      throw InvalidCodeException.from(element, 'need first parameter as "Request request".');
    }

    for (final pathParam in pathParams) {
      if (!parametersIterator.moveNext()) {
        throw InvalidCodeException.from(element, 'not has "$pathParam" path parameter.');
      }
      final parameter = parametersIterator.current;

      if (pathParam != parameter.name) {
        throw InvalidCodeException.from(
            parameter, 'has name different to path param "$pathParam".');
      }
      if (!parameter.type.isPrimitive || parameter.type.isNullable) {
        throw InvalidCodeException.from(parameter, 'has unsupported type.');
      }
      pathParameters.add(parameter);
    }

    if (parametersIterator.moveNext()) {
      if (verb == 'GET') {
        throw InvalidCodeException.from(element, '"GET" endpoint cannot have a body.');
      }
      final parameter = parametersIterator.current;
      final parameterElement = parameter.type.element! as ClassElement;
      final parameterTypeName = parameter.type.getDisplayString(withNullability: false);
      if (parameterElement.constructors.every((e) => e.name != 'fromJson')) {
        throw InvalidCodeException.from(parameterElement,
            'add "factory $parameterTypeName.fromJson(Map<String, dynamic> map)" constructor.');
      }
      bodyParameter = parameter;
    }

    if (parametersIterator.moveNext()) {
      throw InvalidCodeException.from(element, 'has many parameters.');
    }

    // final headerParameters =
    //     element.parameters.where((e) => e.isNamed && _headerChecker.hasAnnotationOf(e)).toList();
    final queryParameters = element.parameters.where((e) => e.isNamed).toList();

    return RouteHandler._(
      method: verb,
      path: route,
      element: element,
      bodyParameter: bodyParameter,
      hasRequest: true,
      pathParameters: pathParameters,
      headerParameters: [],
      queryParameters: queryParameters,
      returns: getReturns(element.returnType),
    );
  }

  static RouteReturnsType getReturns(DartType type) {
    final returnType = type.isDartAsyncFuture || type.isDartAsyncFuture
        ? (type as InterfaceType).typeArguments.single
        : type;

    if (returnType is VoidType) return RouteReturnsType.nothing;

    if (returnType.isJson) return RouteReturnsType.json;

    final returnElement = returnType.element;
    if (returnElement is ClassElement) {
      if (responseChecker.isAssignableFromType(returnType)) return RouteReturnsType.response;
      if (returnElement.methods.every((element) => element.name != 'toJson')) {
        throw InvalidCodeException(
            'Please implement "Map<String, dynamic> ${returnElement.name}.toJson()" method.');
      }
      return RouteReturnsType.json;
    }

    final typeName = type.getDisplayString(withNullability: false);
    throw InvalidCodeException('Please update $typeName with valid returns json value.');
  }

  void _validate() {
    for (final parameter in headerParameters) {
      final type = parameter.type;
      if (type.isPrimitive) continue;

      final listType = type.asDartCoreList;
      if (listType?.typeArguments.single.isPrimitive ?? false) continue;

      throw InvalidCodeException.from(parameter, 'has unsupported type.');
    }
    for (final parameter in queryParameters) {
      final type = parameter.type;
      if (type.isPrimitive) continue;

      final listType = type.asDartCoreList;
      if (listType?.typeArguments.single.isPrimitive ?? false) continue;

      throw InvalidCodeException.from(parameter, 'has unsupported type.');
    }
  }
}
