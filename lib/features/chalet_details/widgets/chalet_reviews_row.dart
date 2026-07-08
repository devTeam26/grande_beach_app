import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

/// Minimal rating summary row: star rating, a vertical divider, review count.
class ChaletReviewsRow extends StatelessWidget {
  const ChaletReviewsRow({
    super.key,
    required this.rating,
    required this.totalReviews,
  });

  final double rating;
  final int totalReviews;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
              padding: const EdgeInsets.symmetric(vertical: 8),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryGold,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                rating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              const Icon(
                Icons.star_rounded,
                color: AppColors.primaryGold,
                size: 18,
              ),
            ],
          ),
          Container(
            width: 1,
            height: 45,
            color: theme.dividerColor,
          ),
          Column(
            children: [
              Text(
                '$totalReviews',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.reviews,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
