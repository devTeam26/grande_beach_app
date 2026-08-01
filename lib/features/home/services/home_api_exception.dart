/// Thrown when a home chalets endpoint responds with `success: false`.
class HomeApiException implements Exception {
  const HomeApiException(this.message);

  final String message;
}
