import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class LoginFooterLinks extends StatelessWidget {
  const LoginFooterLinks({super.key, required this.onSignUp});

  final VoidCallback onSignUp;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l10n.dontHaveAccount),
        TextButton(
          onPressed: onSignUp,
          child: Text(
            l10n.signUp,
            style: const TextStyle(
              color: AppColors.primaryGold,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
