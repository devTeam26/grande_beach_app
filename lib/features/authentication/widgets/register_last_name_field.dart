import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';

class RegisterLastNameField extends StatelessWidget {
  const RegisterLastNameField({
    super.key,
    required this.controller,
    this.errorText,
  });

  final TextEditingController controller;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppTextField(
      controller: controller,
      label: l10n.lastName,
      hint: l10n.lastNameHint,
      textInputAction: TextInputAction.next,
      fillColor: AppColors.inputFill(Theme.of(context).brightness),
      borderColor: Colors.transparent,
      focusedBorderColor: Colors.transparent,
      validator: (_) => errorText,
    );
  }
}
