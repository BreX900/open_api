import 'package:shelf/shelf.dart';

const _contextKey = '@provider-container';

typedef Getter = T Function<T extends Object>();

extension ReadProviderRequest on Request {
  T get<T extends Object>() {
    final getter = context[_contextKey] as Getter?;
    assert(getter != null,
        'Missing getter scope in request context.\nUse getterScope method to provider it.');

    return getter!<T>();
  }
}

Middleware getterScope(Getter getter) {
  return (innerHandler) {
    return (request) async {
      return await innerHandler(request.change(context: {_contextKey: getter}));
    };
  };
}
