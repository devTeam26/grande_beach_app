import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_icons.dart';
import '../../../core/errors/failure.dart';
import '../../../core/extensions/failure_localization_extension.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/status_info_banner.dart';
import '../controllers/forgot_password_controller.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/forgot_password_header.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  // Prevents the provider's initial AsyncLoading→AsyncData transition from
  // being treated as a successful user submission.
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    _submitted = true;
    ref
        .read(forgotPasswordControllerProvider.notifier)
        .sendResetEmail(email: _emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(forgotPasswordControllerProvider);

    ref.listen<AsyncValue<String?>>(forgotPasswordControllerProvider, (
      previous,
      next,
    ) {
      if (_submitted &&
          next is AsyncData &&
          !next.isLoading &&
          previous?.isLoading == true) {
        _submitted = false;
        // The login screen shows the confirmation snackbar.
        Navigator.of(context).pop(next.value ?? '');
      }
      if (next.hasError) {
        _submitted = false;
        final error = next.error;
        final message = error is Failure
            ? error.localizedMessageWithErrors(context)
            : l10n.errorUnknown;
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
        child: Column(
          children: [
            Expanded(
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
                        textInputAction: TextInputAction.done,
                        errorText: fieldErrors?['email']?.first,
                        onSubmitted: _submit,
                      ),
                      const SizedBox(height: 16),
                      StatusInfoBanner(
                        message: l10n.forgotPasswordCheckEmailHint,
                        icon: AppIcons.email,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            // Pinned to the bottom; rises above the keyboard when it opens.
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: AppButton(
                label: l10n.confirm,
                isLoading: state.isLoading,
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
