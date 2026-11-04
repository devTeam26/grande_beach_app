import '../../../core/errors/failure.dart';

/// Thrown by [GoogleSignInService] when no Google ID token could be obtained.
class GoogleAuthException implements Exception {
  const GoogleAuthException(this.reason, [this.debugMessage]);

  final GoogleSignInFailureReason reason;

  /// Diagnostic detail from the Google SDK. Never shown to the user.
  final String? debugMessage;

  @override
  String toString() => 'GoogleAuthException($reason, $debugMessage)';
}
