import '../../../core/utils/result.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Future<Result<UserModel>> login({
    required String email,
    required String password,
  });

  Future<Result<UserModel>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required String preferredLanguage,
  });

  /// Resets the user's password. The [token] is a one-time backend token;
  /// pass an empty string until the full reset flow is available.
  Future<Result<void>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  });

  Future<bool> hasActiveSession();

  /// Attempts to refresh the session using the stored refresh token.
  ///
  /// On success, persists the rotated tokens (and the profile, if the backend
  /// returned one) and returns [Success]. When there is no stored token, or
  /// the token is invalid/expired, the local session is cleared and a
  /// [Result] failure is returned so the caller can route to login. When the
  /// device is offline (or the server is unreachable), the existing session is
  /// left intact and [Success] is returned — the user is not forced into a
  /// login they cannot complete.
  Future<Result<void>> refreshSession();

  /// Logs the user out: invalidates the server session and clears local
  /// tokens + cached profile. Always succeeds locally even if the API call
  /// fails (best-effort server invalidation).
  Future<Result<void>> logout();
}
