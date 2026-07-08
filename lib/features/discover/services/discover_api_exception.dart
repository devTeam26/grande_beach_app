/// Thrown when the /api/Chalets endpoint responds with `success: false`.
class DiscoverApiException implements Exception {
  const DiscoverApiException(this.message);

  final String message;
}
