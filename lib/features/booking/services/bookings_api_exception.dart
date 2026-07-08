/// Thrown when the /api/Bookings/my endpoint responds with `success: false`.
class BookingsApiException implements Exception {
  const BookingsApiException(this.message);

  final String message;
}
