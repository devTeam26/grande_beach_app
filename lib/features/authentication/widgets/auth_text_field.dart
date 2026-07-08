import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';

/// Shared text field pre-configured with the auth screens' style:
/// grey fill, no border. Pass [prefixIcon] for icon-prefixed fields.
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon,
    this.errorText,
    this.onSubmitted,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Widget? prefixIcon;
  final String? errorText;
  final VoidCallback? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      prefixIcon: prefixIcon,
      fillColor: AppColors.inputFill(Theme.of(context).brightness),
      borderColor: Colors.transparent,
      focusedBorderColor: Colors.transparent,
      validator: (_) => errorText,
      onSubmitted: onSubmitted != null ? (_) => onSubmitted!() : null,
      inputFormatters: inputFormatters,
    );
  }
}
