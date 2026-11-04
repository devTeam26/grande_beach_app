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

  // Which sign-in method is in flight, so only its button shows a spinner.
  // Updated right before the provider changes state, which triggers the
  // rebuild — no setState needed.
  bool _googleSubmitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    _submitted = true;
    _googleSubmitted = false;
    ref
        .read(loginControllerProvider.notifier)
        .login(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  void _signInWithGoogle() {
    _submitted = true;
    _googleSubmitted = true;
    ref.read(loginControllerProvider.notifier).loginWithGoogle();
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
    // Pops with the backend's confirmation message once the email is sent.
    final message = await context.push<String>('/forgot-password');
    if (!mounted || message == null) return;
    final l10n = AppLocalizations.of(context);
    final sentMessage = message.trim().isEmpty ? l10n.resetEmailSent : message;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$sentMessage\n${l10n.checkInboxAndSpam}')),
    );
  }

  /// Shared by email/password and Google sign-in. When the screen was pushed
  /// (a guest tapped Login on Bookings, Profile or the reservation Reserve
  /// dialog) it pops back with `true`, so the caller — e.g. the reservation
  /// wizard with its draft still in memory — resumes exactly where it was.
  /// Otherwise it is the root route and continues to /home as before.
  void _onSignedIn() {
    if (context.canPop()) {
      context.pop(true);
    } else {
      context.go('/home');
    }
  }

  /// Leaving without signing in keeps the user a guest: pop back to the
  /// caller when pushed, or continue to /home when this is the root route.
  void _leaveAsGuest() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(loginControllerProvider);

    ref.listen<AsyncValue<void>>(loginControllerProvider, (previous, next) {
      if (_submitted && next is AsyncData && previous?.isLoading == true) {
        _submitted = false;
        _onSignedIn();
      }
      if (next.hasError) {
        _submitted = false;
        final error = next.error;
        final message = error is Failure
            ? error.localizedMessageWithErrors(context)
            : AppLocalizations.of(context).errorUnknown;
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
    final isGoogleLoading = state.isLoading && _googleSubmitted;

    final canPop = context.canPop();

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _leaveAsGuest();
      },
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          leading: canPop
              ? BackButton(onPressed: _leaveAsGuest)
              : CloseButton(onPressed: _leaveAsGuest),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
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
                      child: Icon(
                        AppIcons.email,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
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
                      child: Icon(
                        AppIcons.lock,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    errorText: fieldErrors?['password']?.first,
                    onSubmitted: _submit,
                  ),
                  LoginForgotPasswordLink(onPressed: _goToForgotPassword),
                  const SizedBox(height: 48),
                  AppButton(
                    label: l10n.signIn,
                    isLoading: state.isLoading && !_googleSubmitted,
                    onPressed: isGoogleLoading ? null : _submit,
                  ),
                  LoginFooterLinks(
                    onSignUp: _goToRegister,
                    onGoogleSignIn: state.isLoading ? null : _signInWithGoogle,
                    isGoogleLoading: isGoogleLoading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
