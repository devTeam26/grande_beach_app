/// Thrown when /api/Chalets/{id} responds with `success: false`.
class ChaletDetailsApiException implements Exception {
  const ChaletDetailsApiException(this.message);

  final String message;
}
