import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

/// Numeric +/- input for guest count, clamped to `[1, maxGuests]`.
class GuestCountStepper extends StatelessWidget {
  const GuestCountStepper({
    super.key,
    required this.value,
    required this.maxGuests,
    required this.onChanged,
  });

  final int? value;
  final int maxGuests;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final count = value ?? 0;
    final exceedsMax = count > maxGuests;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.guestCountLabel, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.inputFill(theme.brightness),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: count > 1 ? () => onChanged(count - 1) : null,
                icon: const Icon(Icons.remove_circle_outline),
                color: AppColors.primaryGold,
              ),
              Text(
                '$count',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              IconButton(
                onPressed:
                    count < maxGuests ? () => onChanged(count + 1) : null,
                icon: const Icon(Icons.add_circle_outline),
                color: AppColors.primaryGold,
              ),
            ],
          ),
        ),
        if (exceedsMax) ...[
          const SizedBox(height: 6),
          Text(
            l10n.guestCountMaxError('$maxGuests'),
            style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
