import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Five tappable stars for picking a 1-5 rating, used by [SubmitReviewSheet].
class RatingInput extends StatelessWidget {
  const RatingInput({
    super.key,
    required this.rating,
    required this.onChanged,
    this.size = 36,
  });

  final int rating;
  final ValueChanged<int> onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    final emptyColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.25);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        final filled = starValue <= rating;
        return IconButton(
          onPressed: () => onChanged(starValue),
          icon: Icon(
            filled ? Icons.star_rounded : Icons.star_outline_rounded,
            size: size,
            color: filled ? AppColors.primaryGold : emptyColor,
          ),
        );
      }),
    );
  }
}
