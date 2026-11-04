import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import 'auth_or_label.dart';
import 'google_sign_in_button.dart';

class LoginFooterLinks extends StatelessWidget {
  const LoginFooterLinks({
    super.key,
    required this.onSignUp,
    required this.onGoogleSignIn,
    this.isGoogleLoading = false,
  });

  final VoidCallback onSignUp;

  /// Null disables the Google button (e.g. while another sign-in runs).
  final VoidCallback? onGoogleSignIn;
  final bool isGoogleLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
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
        ),
        const SizedBox(height: 8),
        const AuthOrLabel(),
        const SizedBox(height: 16),
        GoogleSignInButton(
          onPressed: onGoogleSignIn,
          isLoading: isGoogleLoading,
        ),
        ////// remove google sign in for ios version
      ],
    );
  }
}
