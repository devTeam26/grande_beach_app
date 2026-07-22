/// Thrown when the /api/reviews/chalet/{chaletId} endpoint responds with
/// `success: false`.
class ReviewsApiException implements Exception {
  const ReviewsApiException(this.message);

  final String message;
}
