import 'package:flutter/material.dart';

import '../../../core/config/images.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';

class LoginEmailField extends StatelessWidget {
  final bool showIcon;
  const LoginEmailField({
    super.key,
    required this.controller,
    this.errorText,
    this.showIcon = true,
  });

  final TextEditingController controller;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppTextField(
      controller: controller,
      label: l10n.email,
      hint: l10n.emailHint,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      prefixIcon: showIcon
          ? Padding(
              padding: const EdgeInsets.all(14),
              child: Image.asset(AppImages.emailIcon),
            )
          : null,
      fillColor: AppColors.inputFill(Theme.of(context).brightness),
      borderColor: Colors.transparent,
      focusedBorderColor: Colors.transparent,
      validator: (_) => errorText,
    );
  }
}
