import 'package:dio/dio.dart';

import '../../storage/secure_storage_service.dart';

/// Clears the local session when the backend reports the access token as
/// unauthorized/expired, forcing the user back to the login screen.
///
/// There is no refresh-token endpoint defined yet; once one is added this
/// interceptor is the place to call it and retry the original request.
class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor(this._secureStorage);

  final SecureStorageService _secureStorage;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _secureStorage.clearSession();
    }
    handler.next(err);
  }
}
