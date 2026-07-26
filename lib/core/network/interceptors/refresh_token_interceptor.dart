import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../storage/secure_storage_service.dart';

/// Clears the local session when the backend reports the access token as
/// unauthorized/expired, forcing the user back to the login screen.
///
/// The token is proactively refreshed at app launch (see
/// [AuthRepository.refreshSession]); this interceptor is the mid-session
/// backstop — if a request comes back 401 while the app is in use, the local
/// session is cleared so the router redirects to login.
class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor(this._secureStorage);

  final SecureStorageService _secureStorage;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      debugPrint(
        '[AUTH] 401 on ${err.requestOptions.path} mid-session -> clearing '
        'local session',
      );
      await _secureStorage.clearSession();
    }
    handler.next(err);
  }
}
