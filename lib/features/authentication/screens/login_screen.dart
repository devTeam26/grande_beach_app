import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_icons.dart';
import '../../../core/errors/failure.dart';
import '../../../core/extensions/failure_localization_extension.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/app_button.dart';
import '../controllers/login_controller.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/login_footer_links.dart';
import '../widgets/login_forgot_password_link.dart';
import '../widgets/login_header.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    _submitted = true;
    ref.read(loginControllerProvider.notifier).login(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  Future<void> _goToRegister() async {
    final registeredEmail = await context.push<String>('/register');
    if (!mounted || registeredEmail == null) return;
    _emailController.text = registeredEmail;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).registrationSuccess)),
    );
  }

  Future<void> _goToForgotPassword() async {
    final resetEmail = await context.push<String>('/forgot-password');
    if (!mounted || resetEmail == null) return;
    _emailController.text = resetEmail;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).resetPasswordSuccess),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(loginControllerProvider);

    ref.listen<AsyncValue<void>>(loginControllerProvider, (previous, next) {
      if (_submitted && next is AsyncData && previous?.isLoading == true) {
        _submitted = false;
        context.go('/home');
      }
      if (next.hasError) {
        _submitted = false;
        final error = next.error;
        final message = error is Failure
            ? error.localizedMessage(context)
            : error.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _formKey.currentState?.validate();
        });
      }
    });

    final fieldErrors = state.error is ValidationFailure
        ? (state.error as ValidationFailure).fieldErrors
        : null;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LoginHeader(),
                AuthTextField(
                  controller: _emailController,
                  label: l10n.email,
                  hint: l10n.emailHint,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Icon(AppIcons.email, color: Theme.of(context).colorScheme.onSurface),
                  ),
                  errorText: fieldErrors?['email']?.first,
                ),
                const SizedBox(height: 16),
                AuthPasswordField(
                  controller: _passwordController,
                  label: l10n.password,
                  hint: l10n.passwordHint,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Icon(AppIcons.lock, color: Theme.of(context).colorScheme.onSurface),
                  ),
                  errorText: fieldErrors?['password']?.first,
                  onSubmitted: _submit,
                ),
                LoginForgotPasswordLink(onPressed: _goToForgotPassword),
                const SizedBox(height: 48),
                AppButton(
                  label: l10n.signIn,
                  isLoading: state.isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 8),
                LoginFooterLinks(onSignUp: _goToRegister),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
