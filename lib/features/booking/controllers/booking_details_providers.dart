import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/booking.dart';
import 'bookings_providers.dart';

/// Fetches a single booking by id for the Booking Details screen.
final bookingDetailsProvider =
    FutureProvider.family<Booking, String>((ref, id) async {
  final result = await ref.watch(bookingsRepositoryProvider).fetchBookingById(id);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (booking) => booking,
  );
});
