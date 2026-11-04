import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/empty_state.dart';

/// Placeholder shown to guests on screens whose content belongs to an
/// account (e.g. Bookings), with a Login call to action.
class SignInRequiredState extends StatelessWidget {
  const SignInRequiredState({
    super.key,
    required this.message,
    required this.onLogin,
    this.icon = Icons.lock_outline,
  });

  final String message;
  final VoidCallback onLogin;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EmptyState(
              title: l10n.loginRequiredTitle,
              subtitle: message,
              icon: icon,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: AppButton(label: l10n.login, onPressed: onLogin),
            ),
          ],
        ),
      ),
    );
  }
}
