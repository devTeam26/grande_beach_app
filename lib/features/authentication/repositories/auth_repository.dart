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

  /// Logs the user out: invalidates the server session and clears local
  /// tokens + cached profile. Always succeeds locally even if the API call
  /// fails (best-effort server invalidation).
  Future<Result<void>> logout();
}
