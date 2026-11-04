import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Compact stadium-shaped button used in [AppActionDialog]'s action row.
///
/// The primary variant matches [AppButton] (black in light mode, primary
/// gold in dark mode); the secondary variant is a neutral filled pill used
/// for Cancel.
class AppDialogPillButton extends StatelessWidget {
  const AppDialogPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isPrimary
        ? (isDark ? AppColors.primaryGold : Colors.black)
        : AppColors.inputFill(theme.brightness);
    final foregroundColor =
        isPrimary ? Colors.white : theme.colorScheme.onSurface;

    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        disabledBackgroundColor: backgroundColor.withValues(alpha: 0.6),
        disabledForegroundColor: foregroundColor.withValues(alpha: 0.6),
        shape: const StadiumBorder(),
        minimumSize: const Size(88, 44),
        padding: const EdgeInsets.symmetric(horizontal: 22),
        textStyle: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      child: isLoading
          ? SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: foregroundColor,
              ),
            )
          : Text(label),
    );
  }
}
