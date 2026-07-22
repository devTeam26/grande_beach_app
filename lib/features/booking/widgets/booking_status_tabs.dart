import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../models/booking_status.dart';

/// Segmented tab bar switching between Ongoing / Completed / Canceled.
class BookingStatusTabs extends StatelessWidget {
  const BookingStatusTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final BookingTab selected;
  final ValueChanged<BookingTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.inputFill(theme.brightness),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: BookingTab.values.map((tab) {
          final isSelected = tab == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryGold : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  // border: isSelected
                  //     ? null
                  //     : Border.all(
                  //         color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  //       ),
                ),
                child: Text(
                  tab.label(l10n),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? Colors.white
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
