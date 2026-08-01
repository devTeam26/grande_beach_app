import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../models/rating_summary.dart';
import 'star_rating_row.dart';

/// Average-rating card shown above the rating filter tabs: a big rounded
/// average with its star row and review count on the left, and a per-star
/// percentage breakdown on the right.
class GuestReviewsSummaryCard extends StatelessWidget {
  const GuestReviewsSummaryCard({super.key, required this.summary});

  final RatingSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final roundedAverage = summary.averageRating.round().clamp(0, 5);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$roundedAverage',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              StarRatingRow(rating: roundedAverage, size: 16),
              const SizedBox(height: 4),
              Text(
                '${summary.totalCount} ${l10n.reviews}',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Container(
            width: 1,
            height: 90,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                for (var star = 5; star >= 1; star--)
                  Padding(
                    padding: EdgeInsets.only(bottom: star > 1 ? 6 : 0),
                    child: _RatingBarRow(
                      star: star,
                      percentage: summary.percentageFor(star),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingBarRow extends StatelessWidget {
  const _RatingBarRow({required this.star, required this.percentage});

  final int star;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trackColor = theme.colorScheme.onSurface.withValues(alpha: 0.1);

    return Row(
      children: [
        SizedBox(
          width: 10,
          child: Text(
            '$star',
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Icon(Icons.star_rounded, size: 12, color: AppColors.primaryGold),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Container(height: 6, color: trackColor),
                FractionallySizedBox(
                  widthFactor: (percentage / 100).clamp(0, 1),
                  child: Container(height: 6, color: AppColors.primaryGold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 32,
          child: Text(
            '${percentage.round()}%',
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 11,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }
}
