import 'package:code_builder/code_builder.dart';
import 'package:open_api_client_generator/src/code_utils/reference_utils.dart';
import 'package:open_api_client_generator/src/options/context.dart';
import 'package:open_api_spec/open_api_spec.dart';

extension SchemaToType on ContextMixin {
  Reference schemaToType(SchemaOpenApi schema, {Reference? target}) {
    switch (schema.format) {
      case FormatOpenApi.int32:
      case FormatOpenApi.int64:
        return target ?? References.int;
      case FormatOpenApi.float:
      case FormatOpenApi.double:
        return target ?? References.double;
      case FormatOpenApi.date:
      case FormatOpenApi.dateTime:
        return target ?? References.dateTime;
      case FormatOpenApi.uuid:
      case FormatOpenApi.email:
        return target ?? References.string;

      case FormatOpenApi.url:
      case FormatOpenApi.uri:
        return References.uri;
      case FormatOpenApi.binary:
      case FormatOpenApi.base64:
        // TODO: Handle this case.
        break;
      case null:
        break;
    }

    switch (schema.type) {
      case TypeOpenApi.boolean:
        return target ?? References.bool;
      case TypeOpenApi.integer:
        return target ?? References.int;
      case TypeOpenApi.number:
        return target ?? References.num;
      case TypeOpenApi.string:
        return target ?? References.string;
      case TypeOpenApi.array:
        return References.list(schemaToType(schema.items!));
      case TypeOpenApi.object:
        if (schema.title != null) return Reference(schema.title!);

        final additionalProperties = schema.additionalProperties;
        return References.map(
          key: References.string,
          value: additionalProperties != null ? schemaToType(additionalProperties) : null,
        );
      case null:
        return References.jsonValue;
    }
  }
}
