import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';
import '../utils/password_policy.dart';
import 'auth_providers.dart';

class ForgotPasswordController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final validationFailure = _validate(
      email: email,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
    if (validationFailure != null) {
      state = AsyncError(validationFailure, StackTrace.current);
      return;
    }

    state = const AsyncLoading();

    // Token is simulated with an empty string until the backend provides
    // the complete email-based reset flow (OTP / magic link).
    const simulatedToken = '';

    final result = await ref.read(authRepositoryProvider).resetPassword(
          email: email.trim(),
          token: simulatedToken,
          newPassword: newPassword,
        );

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }

  Failure? _validate({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) {
    final l10n = lookupAppLocalizations(ref.read(localeProvider));
    final fieldErrors = <String, List<String>>{};

    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      fieldErrors['email'] = [l10n.errorEmailRequired];
    } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(trimmedEmail)) {
      fieldErrors['email'] = [l10n.errorEmailInvalid];
    }

    if (newPassword.isEmpty) {
      fieldErrors['newPassword'] = [l10n.errorPasswordRequired];
    } else if (!PasswordPolicy.isValid(newPassword)) {
      fieldErrors['newPassword'] = [l10n.errorPasswordRequirementsNotMet];
    }

    if (confirmPassword.isEmpty) {
      fieldErrors['confirmPassword'] = [l10n.errorConfirmPasswordRequired];
    } else if (confirmPassword != newPassword) {
      fieldErrors['confirmPassword'] = [l10n.errorPasswordMismatch];
    }

    if (fieldErrors.isEmpty) return null;
    return ValidationFailure(
      fieldErrors.values.first.first,
      fieldErrors: fieldErrors,
    );
  }
}

final forgotPasswordControllerProvider =
    AsyncNotifierProvider<ForgotPasswordController, void>(
  ForgotPasswordController.new,
);
