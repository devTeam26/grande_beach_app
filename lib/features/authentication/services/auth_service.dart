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

  /// Exchanges a [refreshToken] for a fresh access/refresh token pair.
  /// Throws [AuthApiException] when the refresh token is invalid or expired.
  Future<AuthSessionModel> refresh({required String refreshToken});

  /// Sends a password-reset request. The [token] is a one-time token issued
  /// by the backend reset flow; pass an empty string to simulate until the
  /// full backend flow is wired.
  Future<void> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  });

  /// Signs in with a Google [idToken]; the backend verifies it and returns
  /// the same session payload as [login].
  Future<AuthSessionModel> googleLogin({required String idToken});

  /// Asks the backend to email a password-reset link to [email].
  /// Returns the backend's (generic) confirmation message.
  Future<String> forgotPassword({required String email});

  /// Permanently deletes the signed-in user's account (bearer token is
  /// attached by the auth interceptor). Throws [AuthApiException] when the
  /// backend responds with `success: false`.
  Future<void> deleteAccount();

  /// Invalidates the current session on the server side.
  /// The caller must clear local tokens regardless of the result.
  Future<void> logout({required String accessToken});
}
