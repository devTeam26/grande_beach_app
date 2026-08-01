import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

/// Minimal rating summary row.
/// Tapping it opens the full review list.
class ChaletReviewsRow extends StatelessWidget {
  const ChaletReviewsRow({
    super.key,
    required this.rating,
    required this.totalReviews,
    required this.onTap,
  });

  final double rating;
  final int totalReviews;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primaryGold,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Rating
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.primaryGold,
                          size: 18,
                        ),
                      ],
                    ),

                    Container(
                      width: 1,
                      height: 42,
                      color: theme.dividerColor,
                    ),

                    // Reviews
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$totalReviews',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.reviews,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: .6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // const SizedBox(width: 4),

              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.primaryGold.withValues(alpha: .8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}