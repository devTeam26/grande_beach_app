import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bookings_providers.dart';

/// Tracks whether a cancellation request has been submitted for a given
/// booking id. `true` once `/api/Bookings/{id}/cancel` succeeds.
class CancelBookingController extends FamilyAsyncNotifier<bool, String> {
  @override
  Future<bool> build(String arg) async => false;

  /// Submits the cancellation reason. Returns whether it succeeded.
  Future<bool> cancel(String reason) async {
    state = const AsyncLoading();

    final result = await ref
        .read(bookingsRepositoryProvider)
        .cancelBooking(id: arg, reason: reason);

    return result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncData(true);
        return true;
      },
    );
  }
}

final cancelBookingControllerProvider =
    AsyncNotifierProvider.family<CancelBookingController, bool, String>(
  CancelBookingController.new,
);
