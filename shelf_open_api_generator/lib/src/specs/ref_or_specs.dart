import 'package:json_annotation/json_annotation.dart';

mixin RefOrOpenApi<T> {
  R fold<R>(R Function(String ref) onRef, R Function(T) on);

  String? get ref;

  Map<String, dynamic> toJson();
}

class RefOpenApi<T> with RefOrOpenApi<T> {
  @JsonKey(name: '\$ref')
  @override
  final String ref;

  const RefOpenApi({
    required this.ref,
  });

  @override
  R fold<R>(R Function(String ref) onRef, R Function(T p1) on) {
    return onRef(ref);
  }

  @override
  Map<String, dynamic> toJson() => {'\$ref': ref};
}
