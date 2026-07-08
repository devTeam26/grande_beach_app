import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';

/// Numeric guest-count input. Digits only, minimum of 1.
class GuestsField extends StatelessWidget {
  const GuestsField({
    super.key,
    required this.controller,
    this.errorText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppTextField(
      controller: controller,
      label: l10n.guestsLabel,
      hint: l10n.guestsHint,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      fillColor: AppColors.inputFill(Theme.of(context).brightness),
      borderColor: Colors.transparent,
      focusedBorderColor: Colors.transparent,
      validator: (_) => errorText,
      onChanged: onChanged,
    );
  }
}
