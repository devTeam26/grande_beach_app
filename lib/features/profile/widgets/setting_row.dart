import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// A single row inside a settings section.
///
/// Supports three trailing variants:
/// - Chevron (default) — navigation rows
/// - Value + Chevron — rows that show a current value (e.g. language)
/// - Switch — toggle rows (notifications, dark mode)
class SettingRow extends StatelessWidget {
  const SettingRow({
    super.key,
    required this.icon,
    required this.title,
    this.trailingValue,
    this.onTap,
    this.isDestructive = false,
  }) : _switchValue = null,
       _onSwitchChanged = null;

  const SettingRow.withSwitch({
    super.key,
    required this.icon,
    required this.title,
    required bool switchValue,
    required ValueChanged<bool> onSwitchChanged,
    this.isDestructive = false,
  }) : _switchValue = switchValue,
       _onSwitchChanged = onSwitchChanged,
       trailingValue = null,
       onTap = null;

  final Widget icon;
  final String title;
  final String? trailingValue;
  final VoidCallback? onTap;
  final bool isDestructive;

  final bool? _switchValue;
  final ValueChanged<bool>? _onSwitchChanged;

  bool get _isSwitch => _switchValue != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleColor = isDestructive ? Colors.red : theme.colorScheme.onSurface;
    final iconColor = isDestructive
        ? Colors.red
        : theme.colorScheme.onSurfaceVariant;

    final row = SizedBox(
      height: 60,
      child: Row(
        children: [
          const SizedBox(width: 16),
          IconTheme(
            data: IconThemeData(color: iconColor, size: 22),
            child: icon,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: titleColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (_isSwitch)
            Switch.adaptive(
              value: _switchValue!,
              onChanged: _onSwitchChanged,
              activeThumbColor: Colors.white,
              activeTrackColor: AppColors.primaryGold,
            )
          else ...[
            if (trailingValue != null)
              Text(
                trailingValue!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
          const SizedBox(width: 12),
        ],
      ),
    );

    if (_isSwitch) return row;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: row,
    );
  }
}
