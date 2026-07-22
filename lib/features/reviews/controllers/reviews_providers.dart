import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../core/errors/failure.dart';
import '../../../core/providers/core_providers.dart';
import '../models/review.dart';
import '../repositories/reviews_repository.dart';
import '../repositories/reviews_repository_impl.dart';
import '../services/reviews_service.dart';
import '../services/reviews_service_impl.dart';

const _pageSize = 20;
const _reviewedBookingIdsKey = 'reviewed_booking_ids';

final reviewsServiceProvider = Provider<ReviewsService>((ref) {
  return ReviewsServiceImpl(ref.watch(apiClientProvider).dio);
});

final reviewsRepositoryProvider = Provider<ReviewsRepository>((ref) {
  return ReviewsRepositoryImpl(
    reviewsService: ref.watch(reviewsServiceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

class ReviewsState {
  const ReviewsState({
    required this.reviews,
    required this.totalCount,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  final List<Review> reviews;
  final int totalCount;
  final bool hasMore;
  final bool isLoadingMore;

  ReviewsState copyWith({
    List<Review>? reviews,
    int? totalCount,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ReviewsState(
      reviews: reviews ?? this.reviews,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Paginated reviews for a single chalet, backed by
/// /api/reviews/chalet/{chaletId}. One instance per [chaletId].
class ReviewsNotifier extends FamilyAsyncNotifier<ReviewsState, String> {
  int _page = 1;
  int? _ratingFilter;

  @override
  Future<ReviewsState> build(String chaletId) async {
    _page = 1;
    final result = await ref.read(reviewsRepositoryProvider).fetchReviews(
          chaletId: chaletId,
          pageNumber: _page,
          pageSize: _pageSize,
          rating: _ratingFilter,
        );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (page) => ReviewsState(
        reviews: page.reviews,
        totalCount: page.totalCount,
        hasMore: page.hasMore,
      ),
    );
  }

  Future<void> loadNextPage() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final nextPage = _page + 1;
    final result = await ref.read(reviewsRepositoryProvider).fetchReviews(
          chaletId: arg,
          pageNumber: nextPage,
          pageSize: _pageSize,
          rating: _ratingFilter,
        );

    result.fold(
      (failure) {
        state = AsyncData(current.copyWith(isLoadingMore: false));
      },
      (page) {
        _page = nextPage;
        state = AsyncData(
          current.copyWith(
            reviews: [...current.reviews, ...page.reviews],
            totalCount: page.totalCount,
            hasMore: page.hasMore,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  /// Applies a new star-rating filter (`null` for "All"), resetting to page 1.
  Future<void> setRatingFilter(int? rating) async {
    _ratingFilter = rating;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(arg));
  }

  Future<void> retry() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(arg));
  }
}

final reviewsProvider =
    AsyncNotifierProvider.family<ReviewsNotifier, ReviewsState, String>(
  ReviewsNotifier.new,
);

/// Persists which booking ids already have a review, so the "Write a
/// Review" button stays hidden across app restarts. The backend has no
/// per-booking "already reviewed" flag, so this is the client's own record
/// — kept in sync with the server by [SubmitReviewController].
class ReviewedBookingsNotifier extends Notifier<Set<String>> {
  late Box _box;

  @override
  Set<String> build() {
    _box = ref.watch(hiveBoxProvider);
    final raw = _box.get(_reviewedBookingIdsKey);
    if (raw == null) return {};
    return Set<String>.from((raw as List).cast<String>());
  }

  Future<void> markReviewed(String bookingId) async {
    if (state.contains(bookingId)) return;
    final updated = {...state, bookingId};
    state = updated;
    await _box.put(_reviewedBookingIdsKey, updated.toList());
  }
}

final reviewedBookingsProvider =
    NotifierProvider<ReviewedBookingsNotifier, Set<String>>(
  ReviewedBookingsNotifier.new,
);

/// Fetches every review for a chalet (paginating past the first page) and
/// returns the booking ids they belong to. Used as a source of truth for
/// "already reviewed", since the backend has no per-booking flag and the
/// local [reviewedBookingsProvider] cache only knows about reviews submitted
/// through this app on this device.
final chaletReviewedBookingIdsProvider =
    FutureProvider.family<Set<String>, String>((ref, chaletId) async {
  final repository = ref.watch(reviewsRepositoryProvider);
  final bookingIds = <String>{};
  var page = 1;
  while (true) {
    final result = await repository.fetchReviews(
      chaletId: chaletId,
      pageNumber: page,
      pageSize: 50,
    );
    final reviewsPage = result.fold((failure) => null, (page) => page);
    if (reviewsPage == null) break;

    bookingIds.addAll(reviewsPage.reviews.map((r) => r.bookingId));
    if (!reviewsPage.hasMore) break;
    page++;
  }
  return bookingIds;
});

/// Whether [bookingId] (for [chaletId]) already has a review — checked
/// locally first (fast path for reviews just submitted this session), then
/// against the server as the source of truth so the "Write a Review" button
/// stays hidden even for reviews submitted before this cache existed.
final isBookingReviewedProvider =
    FutureProvider.family<bool, ({String bookingId, String chaletId})>(
        (ref, arg) async {
  if (ref.watch(reviewedBookingsProvider).contains(arg.bookingId)) {
    return true;
  }

  final serverBookingIds =
      await ref.watch(chaletReviewedBookingIdsProvider(arg.chaletId).future);
  final isReviewed = serverBookingIds.contains(arg.bookingId);
  if (isReviewed) {
    ref.read(reviewedBookingsProvider.notifier).markReviewed(arg.bookingId);
  }
  return isReviewed;
});

/// Tracks whether a review has been submitted for a given booking id.
/// `true` once `/api/reviews` succeeds.
class SubmitReviewController extends FamilyAsyncNotifier<bool, String> {
  @override
  Future<bool> build(String arg) async => false;

  /// Submits the review. Returns whether it succeeded.
  Future<bool> submit({required int rating, required String comment}) async {
    state = const AsyncLoading();

    final result = await ref.read(reviewsRepositoryProvider).submitReview(
          bookingId: arg,
          rating: rating,
          comment: comment,
        );

    return result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        // The backend has already rejected this request outright (as
        // opposed to a connectivity failure) — the only realistic reason
        // is that a review already exists for this booking, so remember
        // that locally too rather than showing the button again.
        if (failure is ServerFailure || failure is ValidationFailure) {
          ref.read(reviewedBookingsProvider.notifier).markReviewed(arg);
        }
        return false;
      },
      (_) {
        state = const AsyncData(true);
        ref.read(reviewedBookingsProvider.notifier).markReviewed(arg);
        return true;
      },
    );
  }
}

final submitReviewControllerProvider =
    AsyncNotifierProvider.family<SubmitReviewController, bool, String>(
  SubmitReviewController.new,
);
