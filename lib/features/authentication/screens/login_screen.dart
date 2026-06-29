import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/failure.dart';
import '../../../core/extensions/failure_localization_extension.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/app_button.dart';
import '../controllers/login_controller.dart';
import '../widgets/login_email_field.dart';
import '../widgets/login_footer_links.dart';
import '../widgets/login_forgot_password_link.dart';
import '../widgets/login_header.dart';
import '../widgets/login_password_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).comingSoon)),
    );
  }

  void _submit() {
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);

    ref.listen<AsyncValue<void>>(loginControllerProvider, (previous, next) {
      if (next is AsyncData && !next.isLoading && previous?.isLoading == true) {
        context.go('/home');
      }
      if (next.hasError) {
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
      // appBar: AppBar(leading: const BackButton()),
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
                LoginEmailField(
                  controller: _emailController,
                  errorText: fieldErrors?['email']?.first,
                ),
                const SizedBox(height: 16),
                LoginPasswordField(
                  controller: _passwordController,
                  errorText: fieldErrors?['password']?.first,
                  onSubmitted: _submit,
                ),
                LoginForgotPasswordLink(
                  onPressed: () => _showComingSoon(context),
                ),
                const SizedBox(height: 48),
                AppButton(
                  label: AppLocalizations.of(context).signIn,
                  isLoading: state.isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 8),
                LoginFooterLinks(
                  onSignUp: _goToRegister,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
