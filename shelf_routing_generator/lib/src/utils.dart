import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:shelf/shelf.dart';
import 'package:source_gen/source_gen.dart';

const TypeChecker requestChecker = TypeChecker.fromRuntime(Request);
const TypeChecker responseChecker = TypeChecker.fromRuntime(Response);

bool isHandlerAssignableFromType(DartType type) {
  if (type is InterfaceType) {
    final callMethod = type.getMethod('call');
    if (callMethod == null || callMethod.isStatic) return false;
    type = callMethod.type;
  }

  if (type is! FunctionType) return false;

  // final returnsChecker = TypeChecker.any([
  //   responseChecker,
  //   TypeChecker.fromRuntime(FutureOr<Response>),
  //   TypeChecker.fromRuntime(Future<Response>),
  // ]);

  var returnType = type.returnType;
  returnType = returnType.isDartAsyncFuture || returnType.isDartAsyncFutureOr
      ? (returnType as InterfaceType).typeArguments.single
      : returnType;
  if (!responseChecker.isAssignableFromType(returnType)) return false;

  final parameter = type.parameters.singleOrNull;
  if (parameter == null || !requestChecker.isAssignableFromType(parameter.type)) return false;

  return true;
}

class InvalidCodeException implements Exception {
  final String message;

  InvalidCodeException(this.message);

  factory InvalidCodeException.from(Element element, String description) {
    final enclosingElement = element.enclosingElement;
    var displayName = element.displayName;
    if (enclosingElement != null && enclosingElement is InterfaceElement) {
      displayName = '${enclosingElement.displayName}.$displayName';
    }
    return InvalidCodeException('On $displayName ${element.kind.displayName}: $description');
  }

  @override
  String toString() => message;
}

extension JsonType on DartType {
  bool get isNullable => nullabilitySuffix != NullabilitySuffix.none;

  bool get isPrimitive =>
      isDartCoreBool || isDartCoreInt || isDartCoreDouble || isDartCoreNum || isDartCoreString;

  bool get isJsonPrimitive => isDartCoreNull || isPrimitive;
  bool get isJson => isJsonPrimitive || isDartCoreList || isDartCoreMap;

  InterfaceType? get asDartCoreList => this is InterfaceType ? this as InterfaceType : null;
}

extension X on InterfaceType {
  DartType get typeArgument => typeArguments.single;
}
