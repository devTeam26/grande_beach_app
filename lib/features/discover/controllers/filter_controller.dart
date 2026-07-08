import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chalet_filters.dart';

/// The last filters actually searched with — feeds the Discover chalet list.
class ActiveFiltersNotifier extends Notifier<ChaletFilters> {
  @override
  ChaletFilters build() => const ChaletFilters.empty();

  void apply(ChaletFilters filters) => state = filters;
}

final activeChaletFiltersProvider =
    NotifierProvider<ActiveFiltersNotifier, ChaletFilters>(
  ActiveFiltersNotifier.new,
);

/// Working copy edited while the search bottom sheet is open.
/// `autoDispose` means every time the sheet opens it re-seeds from whatever
/// was last actually searched with, and edits are discarded if the sheet is
/// dismissed without tapping Search.
class DraftFiltersNotifier extends AutoDisposeNotifier<ChaletFilters> {
  @override
  ChaletFilters build() => ref.watch(activeChaletFiltersProvider);

  void setCheckIn(DateTime? value) {
    final cleared = value == null;
    var next = state.copyWith(checkIn: value, clearCheckIn: cleared);
    if (next.checkOut != null &&
        next.checkIn != null &&
        !next.checkOut!.isAfter(next.checkIn!)) {
      next = next.copyWith(clearCheckOut: true);
    }
    state = next;
  }

  void setCheckOut(DateTime? value) {
    state = state.copyWith(checkOut: value, clearCheckOut: value == null);
  }

  void setChaletType(String? value) {
    state = state.copyWith(chaletType: value, clearChaletType: value == null);
  }

  void setGuests(int? value) {
    state = state.copyWith(guests: value, clearGuests: value == null);
  }

  void setMinPrice(double? value) {
    state = state.copyWith(minPrice: value, clearMinPrice: value == null);
  }

  void setMaxPrice(double? value) {
    state = state.copyWith(maxPrice: value, clearMaxPrice: value == null);
  }

  void reset() => state = const ChaletFilters.empty();
}

final draftChaletFiltersProvider =
    AutoDisposeNotifierProvider<DraftFiltersNotifier, ChaletFilters>(
  DraftFiltersNotifier.new,
);
