import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../controllers/reviews_providers.dart';
import 'review_card.dart';
import 'reviews_list_skeleton.dart';

class ReviewsList extends ConsumerStatefulWidget {
  const ReviewsList({super.key, required this.chaletId, this.ratingFilter});

  final String chaletId;

  /// Star rating to narrow the list down to (`null` shows everything).
  /// Applied client-side as a safety net in case the backend doesn't
  /// honor the `rating` query parameter yet.
  final int? ratingFilter;

  @override
  ConsumerState<ReviewsList> createState() => _ReviewsListState();
}

class _ReviewsListState extends ConsumerState<ReviewsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(reviewsProvider(widget.chaletId).notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reviewsAsync = ref.watch(reviewsProvider(widget.chaletId));

    return reviewsAsync.when(
      loading: () => const SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: ReviewsListSkeleton(),
      ),
      error: (_, _) => ErrorState(
        message: l10n.errorLoadingReviews,
        onRetry: () => ref.read(reviewsProvider(widget.chaletId).notifier).retry(),
      ),
      data: (state) {
        final ratingFilter = widget.ratingFilter;
        final reviews = ratingFilter == null
            ? state.reviews
            : state.reviews.where((r) => r.rating == ratingFilter).toList();

        // The currently loaded page(s) may hold zero matches for the
        // selected rating even though later pages do — keep fetching
        // instead of flashing a false "no reviews" state.
        if (reviews.isEmpty && state.hasMore) {
          if (!state.isLoadingMore) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(reviewsProvider(widget.chaletId).notifier).loadNextPage();
            });
          }
          return const SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: ReviewsListSkeleton(itemCount: 2),
          );
        }

        if (reviews.isEmpty) {
          return Center(
            child: EmptyState(
              title: l10n.noReviewsTitle,
              subtitle: l10n.noReviewsSubtitle,
              icon: Icons.star_outline_rounded,
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          itemCount: reviews.length + 1,
          itemBuilder: (context, index) {
            if (index == reviews.length) {
              return state.isLoadingMore
                  ? const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: ReviewsListSkeleton(itemCount: 1),
                    )
                  : const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ReviewCard(review: reviews[index]),
            );
          },
        );
      },
    );
  }
}
