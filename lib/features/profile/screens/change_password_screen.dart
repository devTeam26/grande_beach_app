import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/failure.dart';
import '../../../core/extensions/failure_localization_extension.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/common_header.dart';
import '../../authentication/widgets/auth_password_field.dart';
import '../../authentication/widgets/password_requirements_checklist.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    _submitted = true;
    ref.read(changePasswordControllerProvider.notifier).changePassword(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(changePasswordControllerProvider);

    ref.listen<AsyncValue<void>>(changePasswordControllerProvider,
        (previous, next) {
      if (_submitted && next is AsyncData && previous?.isLoading == true) {
        _submitted = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.passwordChangedSuccess)),
        );
        context.pop();
      }
      if (next.hasError) {
        _submitted = false;
        final error = next.error;
        final message = error is Failure
            ? error.localizedMessage(context)
            : error.toString();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    });

    final fieldErrors = state.error is ValidationFailure
        ? (state.error as ValidationFailure).fieldErrors
        : null;

    return Scaffold(
      body: Column(
        children: [
          CommonHeader(
            title: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.changePassword,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthPasswordField(
                    controller: _currentPasswordController,
                    label: l10n.currentPassword,
                    hint: l10n.currentPasswordHint,
                    textInputAction: TextInputAction.next,
                    errorText: fieldErrors?['currentPassword']?.first,
                  ),
                  const SizedBox(height: 16),
                  AuthPasswordField(
                    controller: _newPasswordController,
                    label: l10n.newPassword,
                    hint: l10n.newPasswordHint,
                    textInputAction: TextInputAction.done,
                    errorText: fieldErrors?['newPassword']?.first,
                    onSubmitted: _submit,
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _newPasswordController,
                    builder: (context, value, _) =>
                        PasswordRequirementsChecklist(password: value.text),
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    label: l10n.save,
                    isLoading: state.isLoading,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
