import 'package:dio/dio.dart';

import '../config/api_strings.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/localization_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/refresh_token_interceptor.dart';

/// Thin wrapper around [Dio], configured with the app's base URL and
/// interceptors. This is the only place that should talk to Dio directly;
/// everything else must go through a repository -> remote data source.
class ApiClient {
  ApiClient({
    required AuthInterceptor authInterceptor,
    required RefreshTokenInterceptor refreshTokenInterceptor,
    required LocalizationInterceptor localizationInterceptor,
  }) : dio = Dio(
          BaseOptions(
            baseUrl: ApiStrings.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            contentType: 'application/json',
          ),
        ) {
    dio.interceptors.addAll([
      authInterceptor,
      localizationInterceptor,
      refreshTokenInterceptor,
      LoggingInterceptor(),
    ]);
  }

  final Dio dio;
}
