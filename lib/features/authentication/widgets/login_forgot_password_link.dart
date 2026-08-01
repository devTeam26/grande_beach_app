import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';

class LoginForgotPasswordLink extends StatelessWidget {
  const LoginForgotPasswordLink({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
      final theme = Theme.of(context);

    final l10n = AppLocalizations.of(context);
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          l10n.forgotPassword,
          style:  TextStyle(
            color:theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
