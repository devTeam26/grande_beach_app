import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';

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
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        child: Text(l10n.continueLabel),
      ),
    );
  }
}
