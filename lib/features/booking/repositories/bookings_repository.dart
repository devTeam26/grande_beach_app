import '../../../core/utils/result.dart';
import '../models/booking.dart';
import '../models/bookings_page.dart';

abstract class BookingsRepository {
  Future<Result<BookingsPage>> fetchMyBookings({
    required int pageNumber,
    required int pageSize,
  });

  Future<Result<Booking>> fetchBookingById(String id);

  Future<Result<void>> cancelBooking({required String id, required String reason});
}
