import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';

/// Shows the reason text for a cancelled or rejected booking.
class CancellationReasonSection extends StatelessWidget {
  const CancellationReasonSection({super.key, required this.reason});

  final String reason;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.cancellationReasonTitle,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          reason,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }
}
