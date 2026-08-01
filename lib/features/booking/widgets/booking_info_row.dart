import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// A single label/value row used inside a [ReceiptSection].
class BookingInfoRow extends StatelessWidget {
  const BookingInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;

  /// Bold, primary-colored value — used for the grand total row.
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
              color: emphasize
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
          Text(
            value,
            style: emphasize
                ? theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryGold,
                  )
                : theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
