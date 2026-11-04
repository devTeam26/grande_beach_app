/// Base type for all domain/network failures returned through [Result].
sealed class Failure {
  const Failure(this.message, {this.errors});

  final String message;

  /// Individual error strings from the backend's error envelope (e.g. its
  /// `errors` array), shown alongside [message] when present.
  final List<String>? errors;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.errors});
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class NoInternetFailure extends Failure {
  const NoInternetFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.fieldErrors, super.errors});

  final Map<String, List<String>>? fieldErrors;
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

/// Why a Google Sign-In attempt ended before reaching the backend.
enum GoogleSignInFailureReason {
  /// The user dismissed the account picker — not an error.
  cancelled,

  /// Google authentication failed or returned no ID token.
  failed,

  /// Google Sign-In is unavailable or misconfigured on this device.
  unavailable,
}

/// The native Google Sign-In step failed (backend errors use the other
/// [Failure] types).
class GoogleSignInFailure extends Failure {
  const GoogleSignInFailure(super.message, {required this.reason});

  final GoogleSignInFailureReason reason;

  bool get isCancelled => reason == GoogleSignInFailureReason.cancelled;
}
