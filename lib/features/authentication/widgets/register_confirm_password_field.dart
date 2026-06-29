import 'package:flutter/material.dart';

import '../../../core/config/images.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';

class RegisterConfirmPasswordField extends StatefulWidget {
  const RegisterConfirmPasswordField({
    super.key,
    required this.controller,
    this.errorText,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String? errorText;
  final VoidCallback? onSubmitted;

  @override
  State<RegisterConfirmPasswordField> createState() =>
      _RegisterConfirmPasswordFieldState();
}

class _RegisterConfirmPasswordFieldState
    extends State<RegisterConfirmPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppTextField(
      controller: widget.controller,
      label: l10n.confirmPassword,
      hint: l10n.confirmPasswordHint,
      obscureText: _obscure,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => widget.onSubmitted?.call(),
      validator: (_) => widget.errorText,
      suffixIcon: GestureDetector(
        onTap: () => setState(() => _obscure = !_obscure),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Image.asset(_obscure ? AppImages.eyeOffIcon : AppImages.eyeIcon),
        ),
      ),
      fillColor: AppColors.inputFill(Theme.of(context).brightness),
      borderColor: Colors.transparent,
      focusedBorderColor: Colors.transparent,
    );
  }
}
