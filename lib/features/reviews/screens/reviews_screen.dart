import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/common_header.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../controllers/reviews_providers.dart';
import '../widgets/guest_reviews_summary_card.dart';
import '../widgets/review_rating_filter.dart';
import '../widgets/reviews_list.dart';

/// Full review list for a chalet, reached from [ChaletReviewsRow]. Lets the
/// user filter reviews by star rating and paginates through the rest.
class ReviewsScreen extends ConsumerStatefulWidget {
  const ReviewsScreen({super.key, required this.chaletId});

  final String chaletId;

  @override
  ConsumerState<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends ConsumerState<ReviewsScreen> {
  int? _ratingFilter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chaletId = widget.chaletId;
    final ratingSummaryAsync = ref.watch(chaletRatingSummaryProvider(chaletId));

    return Scaffold(
      body: Column(
        children: [
          CommonHeader(
            showBackButton: true,
            onBackPressed: () => context.pop(),
            title: Text(
              l10n.reviewsTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ratingSummaryAsync.when(
                  loading: () => const AppShimmer(
                    child: SkeletonBox(
                      height: 20,
                      width: 140,
                      borderRadius: 6,
                    ),
                  ),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (summary) => Row(
                    children: [
                      Text(
                        l10n.guestReviewsTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${summary.totalCount})',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ratingSummaryAsync.when(
                  loading: () => const AppShimmer(
                    child: SkeletonBox(
                      height: 110,
                      width: double.infinity,
                      borderRadius: 16,
                    ),
                  ),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (summary) => summary.totalCount == 0
                      ? const SizedBox.shrink()
                      : GuestReviewsSummaryCard(summary: summary),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: ReviewRatingFilter(
              selected: _ratingFilter,
              onChanged: (rating) {
                setState(() => _ratingFilter = rating);
                ref
                    .read(reviewsProvider(chaletId).notifier)
                    .setRatingFilter(rating);
              },
            ),
          ),
          Expanded(
            child: ReviewsList(chaletId: chaletId, ratingFilter: _ratingFilter),
          ),
        ],
      ),
    );
  }
}
