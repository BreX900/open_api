mixin PrettyJsonToString {
  Map<String, dynamic> toJson();

  @override
  String toString() => '${toJson()}';
}
