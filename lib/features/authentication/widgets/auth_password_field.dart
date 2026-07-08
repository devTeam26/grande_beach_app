import 'package:flutter/material.dart';

import '../../../core/config/app_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';

/// Shared password field pre-configured with the auth screens' style:
/// grey fill, no border, eye-toggle suffix. Pass [prefixIcon] for lock-icon
/// fields (login screen). Omit it for registration/forgot-password fields.
class AuthPasswordField extends StatefulWidget {
  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.errorText,
    this.onSubmitted,
    this.textInputAction = TextInputAction.done,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final Widget? prefixIcon;
  final String? errorText;
  final VoidCallback? onSubmitted;
  final TextInputAction textInputAction;

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
      final theme = Theme.of(context);

    return AppTextField(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      obscureText: _obscure,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted != null ? (_) => widget.onSubmitted!() : null,
      validator: (_) => widget.errorText,
      prefixIcon: widget.prefixIcon,
      suffixIcon: GestureDetector(
        onTap: () => setState(() => _obscure = !_obscure),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Icon(
            _obscure ? AppIcons.eyeOff : AppIcons.eye,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      fillColor: AppColors.inputFill(Theme.of(context).brightness),
      borderColor: Colors.transparent,
      focusedBorderColor: Colors.transparent,
    );
  }
}
