class RoutersSchema {
  final String library;
  final Map<String, String> handlers;

  const RoutersSchema({
    required this.library,
    required this.handlers,
  });

  factory RoutersSchema.fromJson(Map<String, dynamic> map) {
    return RoutersSchema(
      library: map['library'] as String,
      handlers: (map['handlers'] as Map<String, dynamic>).cast<String, String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'library': library,
      'handlers': handlers,
    };
  }
}
