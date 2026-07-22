import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/app_button.dart';

/// Shared Next/Back bar for all wizard steps; the final step's button shows
/// "Reserve" via [label] instead of "Next".
class ReservationBottomBar extends StatelessWidget {
  const ReservationBottomBar({
    super.key,
    required this.currentStep,
    required this.canGoNext,
    required this.onNext,
    required this.onBack,
    this.label,
    this.isLoading = false,
    this.onDisabledTap,
  });

  final int currentStep;
  final bool canGoNext;
  final VoidCallback onNext;
  final VoidCallback? onBack;

  /// Overrides the default "Next" label — used for the final step's
  /// "Reserve" button.
  final String? label;

  /// Shows a spinner inside the button and disables it, without changing
  /// [canGoNext] (used while a submission is in flight).
  final bool isLoading;

  /// Called when the button is disabled and the user taps it anyway — e.g.
  /// to surface a validation message.
  final VoidCallback? onDisabledTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final enabled = canGoNext && !isLoading;

    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          if (currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: enabled ? null : onDisabledTap,
              child: AppButton(
                label: label ?? l10n.nextButton,
                isLoading: isLoading,
                onPressed: enabled ? onNext : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
