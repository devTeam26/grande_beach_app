import 'package:flutter/material.dart';

import '../../../core/config/images.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';

class LoginPasswordField extends StatefulWidget {
  final bool showIcon;
  const LoginPasswordField({
    super.key,
    required this.controller,
    this.errorText,
    this.onSubmitted,
    this.showIcon = true,
  });

  final TextEditingController controller;
  final String? errorText;
  final VoidCallback? onSubmitted;

  @override
  State<LoginPasswordField> createState() => _LoginPasswordFieldState();
}

class _LoginPasswordFieldState extends State<LoginPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppTextField(
      controller: widget.controller,
      label: l10n.password,
      hint: l10n.passwordHint,
      obscureText: _obscure,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => widget.onSubmitted?.call(),
      validator: (_) => widget.errorText,
      prefixIcon: widget.showIcon
          ? Padding(
              padding: const EdgeInsets.all(14),
              child: Image.asset(AppImages.lockIcon),
            )
          : null,
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
