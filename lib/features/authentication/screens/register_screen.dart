import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/extensions/failure_localization_extension.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/app_button.dart';
import '../controllers/register_controller.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/password_requirements_checklist.dart';
import '../widgets/register_footer_link.dart';
import '../widgets/register_header.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Prevents the provider's initial AsyncLoading→AsyncData transition from
  // being treated as a successful user submission.
  bool _submitted = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    _submitted = true;
    ref.read(registerControllerProvider.notifier).register(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          phoneNumber: _phoneController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(registerControllerProvider);

    ref.listen<AsyncValue<void>>(registerControllerProvider, (previous, next) {
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
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
                const RegisterHeader(),
                AuthTextField(
                  controller: _firstNameController,
                  label: l10n.firstName,
                  hint: l10n.firstNameHint,
                  errorText: fieldErrors?['firstName']?.first,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _lastNameController,
                  label: l10n.lastName,
                  hint: l10n.lastNameHint,
                  errorText: fieldErrors?['lastName']?.first,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _emailController,
                  label: l10n.email,
                  hint: l10n.emailHint,
                  keyboardType: TextInputType.emailAddress,
                  errorText: fieldErrors?['email']?.first,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _phoneController,
                  label: l10n.phoneNumber,
                  hint: l10n.phoneNumberHint,
                  keyboardType: TextInputType.phone,
                  errorText: fieldErrors?['phoneNumber']?.first,
                ),
                const SizedBox(height: 16),
                AuthPasswordField(
                  controller: _passwordController,
                  label: l10n.password,
                  hint: l10n.passwordHint,
                  textInputAction: TextInputAction.next,
                  errorText: fieldErrors?['password']?.first,
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _passwordController,
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
                  label: l10n.signUp,
                  isLoading: state.isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 24),
                RegisterFooterLink(onSignIn: () => Navigator.of(context).pop()),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
