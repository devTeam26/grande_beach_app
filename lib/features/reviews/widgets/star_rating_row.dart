import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Five stars, filled up to [rating] (1-5), used on review cards.
class StarRatingRow extends StatelessWidget {
  const StarRatingRow({super.key, required this.rating, this.size = 16});

  final int rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    final emptyColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final filled = index < rating;
        return Icon(
          filled ? Icons.star_rounded : Icons.star_outline_rounded,
          size: size,
          color: filled ? AppColors.primaryGold : emptyColor,
        );
      }),
    );
  }
}
