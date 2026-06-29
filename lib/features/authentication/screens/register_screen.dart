import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/extensions/failure_localization_extension.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/app_button.dart';
import '../controllers/register_controller.dart';
import '../widgets/login_email_field.dart';
import '../widgets/login_password_field.dart';
import '../widgets/register_confirm_password_field.dart';
import '../widgets/register_first_name_field.dart';
import '../widgets/register_footer_link.dart';
import '../widgets/register_header.dart';
import '../widgets/register_last_name_field.dart';
import '../widgets/register_phone_field.dart';
import '../widgets/password_requirements_checklist.dart';

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
    ref
        .read(registerControllerProvider.notifier)
        .register(
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
    final state = ref.watch(registerControllerProvider);

    ref.listen<AsyncValue<void>>(registerControllerProvider, (previous, next) {
      if (next is AsyncData && !next.isLoading && previous?.isLoading == true) {
        Navigator.of(context).pop(_emailController.text.trim());
      }
      if (next.hasError) {
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
      appBar: AppBar(leading: const BackButton()),
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
                RegisterFirstNameField(
                  controller: _firstNameController,
                  errorText: fieldErrors?['firstName']?.first,
                ),
                const SizedBox(height: 16),
                RegisterLastNameField(
                  controller: _lastNameController,
                  errorText: fieldErrors?['lastName']?.first,
                ),
                const SizedBox(height: 16),
                LoginEmailField(
                  controller: _emailController,
                  errorText: fieldErrors?['email']?.first,
                  showIcon: false,
                ),
                const SizedBox(height: 16),
                RegisterPhoneField(
                  controller: _phoneController,
                  errorText: fieldErrors?['phoneNumber']?.first,
                ),
                const SizedBox(height: 16),
                LoginPasswordField(
                  controller: _passwordController,
                  errorText: fieldErrors?['password']?.first,
                  showIcon: false,
                ),

                const SizedBox(height: 16),
                RegisterConfirmPasswordField(
                  controller: _confirmPasswordController,
                  errorText: fieldErrors?['confirmPassword']?.first,
                  onSubmitted: _submit,
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _passwordController,
                  builder: (context, value, _) {
                    return PasswordRequirementsChecklist(password: value.text);
                  },
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: AppLocalizations.of(context).signUp,
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
