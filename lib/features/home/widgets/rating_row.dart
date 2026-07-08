import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class RatingRow extends StatelessWidget {
  const RatingRow({
    super.key,
    required this.rating,
    required this.totalReviews,
  });

  final double rating;
  final int totalReviews;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final subtleColor =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, color: AppColors.primaryGold, size: 15),
        const SizedBox(width: 3),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 3),
        Text(
          '(${totalReviews} ${l10n.reviews})',
          style: TextStyle(fontSize: 12, color: subtleColor),
        ),
      ],
    );
  }
}
