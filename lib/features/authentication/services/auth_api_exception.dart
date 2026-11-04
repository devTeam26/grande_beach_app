/// Thrown when the backend responds with HTTP 200 but `success: false`
/// in the standard response envelope (e.g. invalid credentials).
class AuthApiException implements Exception {
  const AuthApiException(this.message, {this.errors});

  final String message;

  /// The backend's `errors` array, if any.
  final List<String>? errors;
}
