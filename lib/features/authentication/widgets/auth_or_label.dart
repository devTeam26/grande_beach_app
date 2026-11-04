import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';

/// Centered "OR" separating alternative sign-in options.
class AuthOrLabel extends StatelessWidget {
  const AuthOrLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        AppLocalizations.of(context).orLabel,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
