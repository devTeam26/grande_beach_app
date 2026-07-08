import '../models/auth_session_model.dart';

abstract class AuthService {
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  });

  Future<AuthSessionModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required String preferredLanguage,
  });

  /// Sends a password-reset request. The [token] is a one-time token issued
  /// by the backend reset flow; pass an empty string to simulate until the
  /// full backend flow is wired.
  Future<void> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  });

  /// Invalidates the current session on the server side.
  /// The caller must clear local tokens regardless of the result.
  Future<void> logout({required String accessToken});
}
