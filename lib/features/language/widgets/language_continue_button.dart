import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class LanguageContinueButton extends StatelessWidget {
  const LanguageContinueButton({
    super.key,
    required this.enabled,
    required this.onPressed,
  });

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: AppColors.primaryGrey,
          disabledBackgroundColor: theme.colorScheme.primary.withValues(alpha: 0.5),
          disabledForegroundColor: AppColors.primaryGrey.withValues(alpha: 0.5),
          shape: const StadiumBorder(),
        ),
        onPressed: enabled ? onPressed : null,
        child: Text(
          l10n.continueLabel,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
