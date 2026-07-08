import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// A selectable chalet type: [value] is the raw string sent to the backend,
/// [label] is the localized text shown to the user.
typedef ChaletTypeOption = ({String value, String label});

/// Deselectable radio-style list — tapping the already-selected option
/// clears the selection.
class ChaletTypeSelector extends StatelessWidget {
  const ChaletTypeSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<ChaletTypeOption> options;
  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: options.map((option) {
        final isSelected = selected == option.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: () => onChanged(isSelected ? null : option.value),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primaryGold : theme.dividerColor,
                  width: isSelected ? 2 : 1,
                ),
                color: theme.colorScheme.surface,
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: isSelected
                        ? AppColors.primaryGold
                        : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    option.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primaryGold
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
