import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:shelf_open_api_generator/src/specs/schema.dart';
import 'package:shelf_open_api_generator/src/utils/doc.dart';
import 'package:source_gen/source_gen.dart';

class SchemasRegistry {
  static final _dateTimeType = TypeChecker.fromRuntime(DateTime);
  static final _uriType = TypeChecker.fromRuntime(Uri);

  final Map<String, _Schema> _schemas = {};

  Map<String, SchemaOrRefOpenApi> get schemas =>
      _schemas.map((key, value) => MapEntry(key, value.value));

  SchemaOrRefOpenApi tryRegister({
    bool isBidirectional = true,
    Doc doc = Doc.none,
    required DartType dartType,
  }) {
    final element = dartType.element;

    final description = doc.summaryAndDescription;
    final example = doc.example;

    if (element is EnumElement) {
      final doc = Doc.from(element.documentationComment);
      final enumValues = element.fields.where((element) => element.isEnumConstant);

      return _register(
        isBidirectional: true,
        refDescription: description,
        refExample: example,
        dartType: dartType,
        name: element.name,
        schema: SchemaOrRefOpenApi(
          description: doc.summaryAndDescription,
          example: doc.example,
          type: TypeOpenApi.string,
          enum$: enumValues.map((e) => e.name).toList(),
        ),
      );
    }

    if (dartType.isDartCoreObject) {
      return SchemaOrRefOpenApi(
        description: description ?? 'Support any json value type.',
        example: example,
      );
    } else if (dartType.isDartCoreBool) {
      return SchemaOrRefOpenApi(
        description: description,
        example: example,
        type: TypeOpenApi.boolean,
      );
    } else if (dartType.isDartCoreNum || dartType.isDartCoreDouble) {
      return SchemaOrRefOpenApi(
        description: description,
        example: example,
        type: TypeOpenApi.number,
        format: dartType.isDartCoreDouble ? FormatOpenApi.double : null,
      );
    } else if (dartType.isDartCoreInt) {
      return SchemaOrRefOpenApi(
        description: description,
        example: example,
        type: TypeOpenApi.integer,
        format: FormatOpenApi.int64,
      );
    } else if (dartType.isDartCoreString ||
        _uriType.isAssignableFromType(dartType) ||
        _dateTimeType.isAssignableFromType(dartType)) {
      return SchemaOrRefOpenApi(
        description: description,
        example: example,
        type: TypeOpenApi.string,
        format: _dateTimeType.isAssignableFromType(dartType)
            ? FormatOpenApi.dateTime
            : (_uriType.isAssignableFromType(dartType) ? FormatOpenApi.uri : null),
      );
    } else if (dartType.isDartCoreIterable || dartType.isDartCoreList) {
      final typeArgument = (dartType as ParameterizedType).typeArguments.single;

      return SchemaOrRefOpenApi(
        description: description,
        example: example,
        type: TypeOpenApi.array,
        items: tryRegister(
          isBidirectional: isBidirectional,
          doc: Doc.none,
          dartType: typeArgument,
        ),
      );
    } else if (dartType.isDartCoreMap) {
      final typeArguments = (dartType as ParameterizedType).typeArguments;

      if (!typeArguments[0].isDartCoreString) {
        throw StateError('Invalid map type. The key type must be a `String` type.');
      }

      return SchemaOrRefOpenApi(
        description: description,
        example: example,
        type: TypeOpenApi.object,
        additionalProperties: tryRegister(
          isBidirectional: isBidirectional,
          dartType: typeArguments[1],
        ),
      );
    } else if (element is ClassElement) {
      final List<_ClassProperty> properties;

      if (isBidirectional) {
        final parameters = element.constructors.firstWhere((e) => e.name.isEmpty).parameters;

        properties = parameters.map((e) {
          return _ClassProperty(
            isRequired: e.type.nullabilitySuffix == NullabilitySuffix.none,
            name: e.name,
            type: e.type,
          );
        }).toList();
      } else {
        properties = element.accessors.where((e) => e.isGetter).map((e) {
          return _ClassProperty(
            isRequired: e.returnType.nullabilitySuffix == NullabilitySuffix.none,
            name: e.name,
            type: e.returnType,
          );
        }).toList();
      }

      return _register(
        isBidirectional: isBidirectional,
        refDescription: description,
        refExample: example,
        dartType: dartType,
        name: element.name,
        schema: SchemaOrRefOpenApi(
          type: TypeOpenApi.object,
          format: null,
          required: properties.where((e) => e.isRequired).map((e) => e.name).toList(),
          properties: {
            for (final property in properties)
              property.name: tryRegister(
                isBidirectional: isBidirectional,
                doc: Doc.from(element.fields.firstWhereOrNull((e) {
                  return e.name == property.name;
                })?.documentationComment),
                dartType: property.type,
              ),
          },
        ),
      );
    }

    log.warning('I cant create $dartType component schema!');
    return SchemaOrRefOpenApi(
      description: 'Unknown value type.',
    );
  }

  SchemaOrRefOpenApi _register({
    required bool isBidirectional,
    required String? refDescription,
    required String? refExample,
    required DartType dartType,
    required String name,
    required SchemaOrRefOpenApi schema,
  }) {
    final ref = SchemaOrRefOpenApi(
      description: refDescription,
      ref: '#/components/schemas/$name',
    );

    final currentSchema = _schemas[name];
    if (currentSchema != null) {
      if (currentSchema.originalType != dartType) {
        log.warning('Already exist $name component schema with different type!\n'
            '${currentSchema.originalType} | $dartType');
      }

      if (currentSchema.isBidirectional) return ref;
    }

    _schemas[name] = _Schema(
      originalType: dartType,
      isBidirectional: isBidirectional,
      value: schema,
    );
    return ref;
  }
}

class _ClassProperty {
  final bool isRequired;
  final DartType type;
  final String name;

  const _ClassProperty({
    required this.isRequired,
    required this.type,
    required this.name,
  });
}

class _Schema {
  final DartType originalType;
  final bool isBidirectional;
  final SchemaOrRefOpenApi value;

  const _Schema({
    required this.originalType,
    required this.isBidirectional,
    required this.value,
  });
}
