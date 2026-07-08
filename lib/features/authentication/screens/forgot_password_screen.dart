import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/extensions/failure_localization_extension.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/app_button.dart';
import '../controllers/forgot_password_controller.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/forgot_password_header.dart';
import '../widgets/password_requirements_checklist.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Prevents the provider's initial AsyncLoading→AsyncData transition from
  // being treated as a successful user submission.
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    _submitted = true;
    ref
        .read(forgotPasswordControllerProvider.notifier)
        .resetPassword(
          email: _emailController.text,
          newPassword: _newPasswordController.text,
          confirmPassword: _confirmPasswordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(forgotPasswordControllerProvider);

    ref.listen<AsyncValue<void>>(forgotPasswordControllerProvider, (
      previous,
      next,
    ) {
      if (_submitted &&
          next is AsyncData &&
          !next.isLoading &&
          previous?.isLoading == true) {
        _submitted = false;
        Navigator.of(context).pop(_emailController.text.trim());
      }
      if (next.hasError) {
        _submitted = false;
        final error = next.error;
        final message = error is Failure
            ? error.localizedMessage(context)
            : error.toString();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _formKey.currentState?.validate();
        });
      }
    });

    final fieldErrors = state.error is ValidationFailure
        ? (state.error as ValidationFailure).fieldErrors
        : null;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        forceMaterialTransparency: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ForgotPasswordHeader(),
                AuthTextField(
                  controller: _emailController,
                  label: l10n.email,
                  hint: l10n.emailHint,
                  keyboardType: TextInputType.emailAddress,
                  errorText: fieldErrors?['email']?.first,
                ),
                const SizedBox(height: 16),
                AuthPasswordField(
                  controller: _newPasswordController,
                  label: l10n.newPassword,
                  hint: l10n.newPasswordHint,
                  textInputAction: TextInputAction.next,
                  errorText: fieldErrors?['newPassword']?.first,
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _newPasswordController,
                  builder: (context, value, _) {
                    return PasswordRequirementsChecklist(password: value.text);
                  },
                ),
                const SizedBox(height: 16),
                AuthPasswordField(
                  controller: _confirmPasswordController,
                  label: l10n.confirmPassword,
                  hint: l10n.confirmPasswordHint,
                  errorText: fieldErrors?['confirmPassword']?.first,
                  onSubmitted: _submit,
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: l10n.confirm,
                  isLoading: state.isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
