import 'booking.dart';

/// A single page of the `/api/Bookings/my` paginated response.
class BookingsPage {
  const BookingsPage({
    required this.bookings,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasMore,
  });

  final List<Booking> bookings;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasMore;
}
