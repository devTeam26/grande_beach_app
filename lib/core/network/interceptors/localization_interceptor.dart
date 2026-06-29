import 'package:dio/dio.dart';

/// Sends the user's selected language to the backend on every request.
class LocalizationInterceptor extends Interceptor {
  LocalizationInterceptor(this._languageCodeProvider);

  final String Function() _languageCodeProvider;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.headers['Accept-Language'] = _languageCodeProvider();
    handler.next(options);
  }
}
