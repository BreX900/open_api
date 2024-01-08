import 'package:shelf/shelf.dart';

typedef RequestGetter = T Function<T extends Object>(Request request);

extension ReadProviderRequest on Request {
  static const String _key = '_getter';

  T get<T extends Object>() {
    final getter = context[_key] as RequestGetter?;

    assert(getter != null,
        'Missing getter scope in request context.\nUse getterScope method to provider it.');

    return getter!<T>(this);
  }

  Request changeWithGetter(RequestGetter getter) => change(context: {_key: getter});
}

Middleware getterMiddleware(RequestGetter getter) {
  return (innerHandler) {
    return (request) {
      return innerHandler(request.changeWithGetter(getter));
    };
  };
}
