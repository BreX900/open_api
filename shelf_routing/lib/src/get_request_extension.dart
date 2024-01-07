import 'package:shelf/shelf.dart';

const _contextKey = '_get';

typedef Get = T Function<T extends Object>(Request request);

extension ReadProviderRequest on Request {
  T get<T extends Object>() {
    final getter = context[_contextKey] as Get?;

    assert(getter != null,
        'Missing getter scope in request context.\nUse getterScope method to provider it.');

    return getter!<T>(this);
  }
}

Middleware getMiddleware(Get get) {
  return (innerHandler) {
    return (request) {
      return innerHandler(request.change(context: {_contextKey: get}));
    };
  };
}
