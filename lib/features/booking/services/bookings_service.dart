import '../models/booking.dart';
import '../models/bookings_page.dart';

abstract class BookingsService {
  Future<BookingsPage> fetchMyBookings({
    required int pageNumber,
    required int pageSize,
  });

  Future<Booking> fetchBookingById(String id);

  Future<void> cancelBooking({required String id, required String reason});
}
