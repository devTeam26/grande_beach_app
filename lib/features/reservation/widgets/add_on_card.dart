import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../models/add_on.dart';
import 'lucide_icon_map.dart';

/// Aliases for add-on icon names that don't map 1:1 onto a Lucide icon name.
const _addOnIconAliases = <String, String>{
  'microphone': 'mic',
  'broom': 'sparkles',
  'towel': 'bath',
  'spa': 'flower-2',
};

/// Resolves a backend-supplied icon name (e.g. `chef-hat`) to a Lucide
/// icon, covering the full Lucide set rather than a small hardcoded list.
IconData _addOnIcon(String icon) {
  final key = _addOnIconAliases[icon] ?? icon;
  return lucideIconsByName[key] ?? LucideIcons.package;
}

/// A single add-on row: icon, name, description, price badge, and a quantity
/// stepper. A [quantity] of zero means the add-on isn't selected.
class AddOnCard extends StatelessWidget {
  const AddOnCard({
    super.key,
    required this.addOn,
    required this.quantity,
    required this.maxQuantity,
    required this.isArabic,
    required this.onIncrement,
    required this.onDecrement,
  });

  final AddOn addOn;
  final int quantity;

  /// Upper bound for [quantity]; the guest can't pick more of an add-on than
  /// there are guests on the booking.
  final int maxQuantity;
  final bool isArabic;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final name = isArabic ? addOn.nameAr : addOn.name;
    final description = isArabic ? addOn.descriptionAr : addOn.description;
    final priceText = '${l10n.kwdCurrency} ${addOn.price.toStringAsFixed(2)}';
    final badge = addOn.isPerNight
        ? l10n.addOnPerNightBadge(priceText)
        : l10n.addOnFlatPriceBadge(priceText);
    final isSelected = quantity > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? AppColors.primaryGold
              : Colors.grey.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _addOnIcon(addOn.icon),
              color: AppColors.primaryGold,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _AddOnQuantityStepper(
            quantity: quantity,
            maxQuantity: maxQuantity,
            onIncrement: onIncrement,
            onDecrement: onDecrement,
          ),
        ],
      ),
    );
  }
}

/// Compact quantity control for an add-on. Before anything is chosen it shows
/// a single "+" button; once the quantity is positive it expands to a
/// "−  qty  +" row.
class _AddOnQuantityStepper extends StatelessWidget {
  const _AddOnQuantityStepper({
    required this.quantity,
    required this.maxQuantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final int maxQuantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canIncrement = quantity < maxQuantity;

    if (quantity == 0) {
      return _StepperButton(
        icon: Icons.add_rounded,
        filled: true,
        onPressed: canIncrement ? onIncrement : null,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepperButton(
          icon: Icons.remove_rounded,
          filled: false,
          onPressed: onDecrement,
        ),
        SizedBox(
          width: 32,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        _StepperButton(
          icon: Icons.add_rounded,
          filled: true,
          onPressed: canIncrement ? onIncrement : null,
        ),
      ],
    );
  }
}

/// A single round +/- button used by [_AddOnQuantityStepper].
class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.filled,
    required this.onPressed,
  });

  final IconData icon;
  final bool filled;

  /// A null callback renders the button in a muted, non-tappable state (e.g.
  /// the "+" once the guest-count cap is reached).
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final Color background;
    final Color foreground;
    if (filled) {
      background = AppColors.primaryGold.withValues(alpha: enabled ? 1 : 0.35);
      foreground = Colors.white;
    } else {
      background = AppColors.primaryGold.withValues(alpha: 0.12);
      foreground = AppColors.primaryGold.withValues(alpha: enabled ? 1 : 0.35);
    }

    return Material(
      color: background,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(icon, size: 20, color: foreground),
        ),
      ),
    );
  }
}
