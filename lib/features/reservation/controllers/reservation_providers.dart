import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../../authentication/controllers/auth_providers.dart';
import '../models/add_on.dart';
import '../models/chalet_availability.dart';
import '../models/price_preview_result.dart';
import '../models/reservation_draft.dart';
import '../models/selected_add_on.dart';
import '../repositories/reservation_repository.dart';
import '../repositories/reservation_repository_impl.dart';
import '../services/reservation_service.dart';
import '../services/reservation_service_impl.dart';

final reservationServiceProvider = Provider<ReservationService>((ref) {
  return ReservationServiceImpl(ref.watch(apiClientProvider).dio);
});

final reservationRepositoryProvider = Provider<ReservationRepository>((ref) {
  return ReservationRepositoryImpl(
    reservationService: ref.watch(reservationServiceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

/// The available add-ons, fetched once per wizard session.
final addOnsProvider = FutureProvider.autoDispose<List<AddOn>>((ref) async {
  final result = await ref.watch(reservationRepositoryProvider).fetchAddOns();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (addOns) => addOns,
  );
});

/// Loads and caches chalet availability for the currently displayed month of
/// the Step 1 calendar. One instance per chalet; it keeps every month it has
/// already fetched in memory for the lifetime of the booking flow, so
/// navigating back to a previously seen month reuses the cached data instead
/// of hitting the network again.
class AvailabilityController
    extends FamilyAsyncNotifier<ChaletAvailability?, String> {
  final Map<String, ChaletAvailability> _cache = {};
  DateTime _month = _monthOf(DateTime.now());

  static DateTime _monthOf(DateTime d) => DateTime(d.year, d.month);

  static String _monthKey(DateTime month) =>
      '${month.year}-${month.month.toString().padLeft(2, '0')}';

  @override
  Future<ChaletAvailability?> build(String chaletId) async => null;

  /// Shows availability for [month]. Reuses the cache when present; otherwise
  /// loads only that month from the backend. Guards against out-of-order
  /// responses when the user pages through months quickly.
  Future<void> showMonth(DateTime month) async {
    final normalized = _monthOf(month);
    _month = normalized;
    final key = _monthKey(normalized);

    final cached = _cache[key];
    if (cached != null) {
      state = AsyncData(cached);
      return;
    }

    state = const AsyncLoading();
    await _load(normalized);
  }

  /// Reloads the current month from the backend, bypassing the cache. Used by
  /// the inline error state's retry button.
  Future<void> retry() async {
    _cache.remove(_monthKey(_month));
    state = const AsyncLoading();
    await _load(_month);
  }

  Future<void> _load(DateTime month) async {
    final from = DateTime(month.year, month.month, 1);
    final to = DateTime(month.year, month.month + 1, 0);

    final result = await ref.read(reservationRepositoryProvider).fetchAvailability(
          chaletId: arg,
          from: from,
          to: to,
        );

    // Discard a stale response if the user has since moved to another month.
    if (_monthKey(month) != _monthKey(_month)) return;

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (availability) {
        _cache[_monthKey(month)] = availability;
        return AsyncData(availability);
      },
    );
  }
}

final availabilityControllerProvider = AsyncNotifierProvider.family<
    AvailabilityController, ChaletAvailability?, String>(
  AvailabilityController.new,
);

/// Holds the in-progress [ReservationDraft] for a single chalet, mutated
/// step-by-step as the user moves through the wizard.
class ReservationWizardController
    extends FamilyAsyncNotifier<ReservationDraft, String> {
  @override
  Future<ReservationDraft> build(String chaletId) async {
    return ReservationDraft(chaletId: chaletId);
  }

  void updateCheckIn(DateTime? checkIn) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(checkIn: checkIn, clearCheckIn: checkIn == null),
    );
  }

  void updateCheckOut(DateTime? checkOut) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(checkOut: checkOut, clearCheckOut: checkOut == null),
    );
  }

  void updateGuestCount(int guestCount) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(guestCount: guestCount));
  }

  void updateSpecialRequest(String specialRequest) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(specialRequest: specialRequest));
  }

  /// Increases the chosen quantity for [addOn] by one, adding it to the draft
  /// with a quantity of one if it wasn't selected yet. An add-on's quantity is
  /// capped at the number of guests on the booking.
  void incrementAddOn(AddOn addOn) {
    final current = state.valueOrNull;
    if (current == null) return;

    final maxQuantity = current.guestCount ?? 1;
    final selected = current.selectedAddOns;
    final index = selected.indexWhere((e) => e.addOn.id == addOn.id);

    final List<SelectedAddOn> updated;
    if (index == -1) {
      if (maxQuantity < 1) return;
      updated = [...selected, SelectedAddOn(addOn: addOn, quantity: 1)];
    } else {
      if (selected[index].quantity >= maxQuantity) return;
      updated = [...selected];
      updated[index] =
          updated[index].copyWith(quantity: updated[index].quantity + 1);
    }

    state = AsyncData(current.copyWith(selectedAddOns: updated));
  }

  /// Decreases the chosen quantity for [addOn] by one, removing it from the
  /// draft entirely once its quantity reaches zero.
  void decrementAddOn(AddOn addOn) {
    final current = state.valueOrNull;
    if (current == null) return;

    final selected = current.selectedAddOns;
    final index = selected.indexWhere((e) => e.addOn.id == addOn.id);
    if (index == -1) return;

    final nextQuantity = selected[index].quantity - 1;
    final List<SelectedAddOn> updated;
    if (nextQuantity <= 0) {
      updated = selected.where((e) => e.addOn.id != addOn.id).toList();
    } else {
      updated = [...selected];
      updated[index] = updated[index].copyWith(quantity: nextQuantity);
    }

    state = AsyncData(current.copyWith(selectedAddOns: updated));
  }

  void setPricePreview(PricePreviewResult preview) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(pricePreview: preview));
  }
}

final reservationWizardControllerProvider = AsyncNotifierProvider.family<
    ReservationWizardController, ReservationDraft, String>(
  ReservationWizardController.new,
);

/// Fetches and holds the price preview for the current draft. Fetched
/// explicitly by the Price Preview step (not built eagerly), since it
/// depends on the draft's current field values at the time of entry.
class PricePreviewController
    extends FamilyAsyncNotifier<PricePreviewResult?, String> {
  @override
  Future<PricePreviewResult?> build(String chaletId) async => null;

  Future<void> fetch(ReservationDraft draft) async {
    final user = ref.read(currentUserProvider);
    if (draft.checkIn == null || draft.checkOut == null || user == null) {
      return;
    }

    state = const AsyncLoading();

    final result =
        await ref.read(reservationRepositoryProvider).fetchPricePreview(
              chaletId: draft.chaletId,
              guestFirstName: user.firstName,
              guestLastName: user.lastName,
              guestEmail: user.email,
              guestPhone: user.phoneNumber ?? '',
              checkInDate: draft.checkIn!,
              checkOutDate: draft.checkOut!,
              guestCount: draft.guestCount ?? 1,
              addOns: draft.selectedAddOns,
            );

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (preview) {
        ref
            .read(reservationWizardControllerProvider(arg).notifier)
            .setPricePreview(preview);
        return AsyncData(preview);
      },
    );
  }
}

final pricePreviewControllerProvider = AsyncNotifierProvider.family<
    PricePreviewController, PricePreviewResult?, String>(
  PricePreviewController.new,
);

/// Submits the completed [ReservationDraft] as a booking, guarding against
/// duplicate in-flight requests. Holds `true` once the booking has been
/// created successfully.
class BookingSubmitController extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async => false;

  Future<void> submit(ReservationDraft draft) async {
    if (state.isLoading) return;

    final user = ref.read(currentUserProvider);
    if (user == null || draft.checkIn == null || draft.checkOut == null) {
      return;
    }

    state = const AsyncLoading();

    final result = await ref.read(reservationRepositoryProvider).createBooking(
          chaletId: draft.chaletId,
          guestFirstName: user.firstName,
          guestLastName: user.lastName,
          guestEmail: user.email,
          guestPhone: user.phoneNumber ?? '',
          checkInDate: draft.checkIn!,
          checkOutDate: draft.checkOut!,
          guestCount: draft.guestCount ?? 1,
          addOns: draft.selectedAddOns,
          specialRequests: draft.specialRequest,
        );

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (_) => const AsyncData(true),
    );
  }
}

final bookingSubmitControllerProvider =
    AsyncNotifierProvider<BookingSubmitController, bool>(
  BookingSubmitController.new,
);
