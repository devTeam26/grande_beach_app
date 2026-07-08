import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../models/booking.dart';
import '../models/booking_status.dart';
import '../repositories/bookings_repository.dart';
import '../repositories/bookings_repository_impl.dart';
import '../services/bookings_service.dart';
import '../services/bookings_service_impl.dart';

const _pageSize = 20;

final bookingsServiceProvider = Provider<BookingsService>((ref) {
  return BookingsServiceImpl(ref.watch(apiClientProvider).dio);
});

final bookingsRepositoryProvider = Provider<BookingsRepository>((ref) {
  return BookingsRepositoryImpl(
    bookingsService: ref.watch(bookingsServiceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

/// Currently selected tab on the Bookings screen.
class BookingTabNotifier extends Notifier<BookingTab> {
  @override
  BookingTab build() => BookingTab.ongoing;

  void select(BookingTab tab) => state = tab;
}

final bookingTabProvider =
    NotifierProvider<BookingTabNotifier, BookingTab>(BookingTabNotifier.new);

class BookingsState {
  const BookingsState({
    required this.bookings,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  final List<Booking> bookings;
  final bool hasMore;
  final bool isLoadingMore;

  BookingsState copyWith({
    List<Booking>? bookings,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return BookingsState(
      bookings: bookings ?? this.bookings,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Paginated list of the authenticated user's bookings, backed by
/// /api/Bookings/my. Tab filtering happens client-side over the loaded list.
class BookingsNotifier extends AsyncNotifier<BookingsState> {
  int _page = 1;

  @override
  Future<BookingsState> build() async {
    _page = 1;
    final result = await ref
        .read(bookingsRepositoryProvider)
        .fetchMyBookings(pageNumber: _page, pageSize: _pageSize);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (page) => BookingsState(bookings: page.bookings, hasMore: page.hasMore),
    );
  }

  Future<void> loadNextPage() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final nextPage = _page + 1;
    final result = await ref
        .read(bookingsRepositoryProvider)
        .fetchMyBookings(pageNumber: nextPage, pageSize: _pageSize);

    result.fold(
      (failure) {
        state = AsyncData(current.copyWith(isLoadingMore: false));
      },
      (page) {
        _page = nextPage;
        state = AsyncData(
          current.copyWith(
            bookings: [...current.bookings, ...page.bookings],
            hasMore: page.hasMore,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  Future<void> retry() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

final bookingsProvider =
    AsyncNotifierProvider<BookingsNotifier, BookingsState>(
  BookingsNotifier.new,
);
