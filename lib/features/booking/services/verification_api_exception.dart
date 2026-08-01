/// Thrown when `/api/Verification` responds with `success: false`.
class VerificationApiException implements Exception {
  const VerificationApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
