class ReservationApiException implements Exception {
  const ReservationApiException(this.message, {this.errors});

  final String message;

  /// The backend's `errors` array, if any (e.g. validation failure reasons).
  final List<String>? errors;

  @override
  String toString() => message;
}
