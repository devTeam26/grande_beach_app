import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';
import '../utils/password_policy.dart';
import 'auth_providers.dart';

/// Drives the register screen. State is [AsyncLoading] while submitting,
/// [AsyncError] holding a [Failure] on validation/network/server errors,
/// and [AsyncData] on success. The user is never auto-logged in here.
class RegisterController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) async {
    final validationFailure = _validate(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      confirmPassword: confirmPassword,
    );
    if (validationFailure != null) {
      state = AsyncError(validationFailure, StackTrace.current);
      return;
    }

    state = const AsyncLoading();
    final preferredLanguage = ref.read(localeProvider).languageCode;
    final result = await ref.read(authRepositoryProvider).register(
          firstName: firstName.trim(),
          lastName: lastName.trim(),
          email: email.trim(),
          phoneNumber: phoneNumber.trim(),
          password: password,
          preferredLanguage: preferredLanguage,
        );

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }

  Failure? _validate({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) {
    final l10n = lookupAppLocalizations(ref.read(localeProvider));
    final fieldErrors = <String, List<String>>{};

    if (firstName.trim().isEmpty) {
      fieldErrors['firstName'] = [l10n.errorFirstNameRequired];
    }
    if (lastName.trim().isEmpty) {
      fieldErrors['lastName'] = [l10n.errorLastNameRequired];
    }

    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      fieldErrors['email'] = [l10n.errorEmailRequired];
    } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(trimmedEmail)) {
      fieldErrors['email'] = [l10n.errorEmailInvalid];
    }

    final trimmedPhone = phoneNumber.trim();
    if (trimmedPhone.isEmpty) {
      fieldErrors['phoneNumber'] = [l10n.errorPhoneRequired];
    } else if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(trimmedPhone)) {
      fieldErrors['phoneNumber'] = [l10n.errorPhoneInvalid];
    }

    if (password.isEmpty) {
      fieldErrors['password'] = [l10n.errorPasswordRequired];
    } else if (!PasswordPolicy.isValid(password)) {
      fieldErrors['password'] = [l10n.errorPasswordRequirementsNotMet];
    }

    if (confirmPassword.isEmpty) {
      fieldErrors['confirmPassword'] = [l10n.errorConfirmPasswordRequired];
    } else if (confirmPassword != password) {
      fieldErrors['confirmPassword'] = [l10n.errorPasswordMismatch];
    }

    if (fieldErrors.isEmpty) return null;
    return ValidationFailure(
      fieldErrors.values.first.first,
      fieldErrors: fieldErrors,
    );
  }
}

final registerControllerProvider =
    AsyncNotifierProvider<RegisterController, void>(RegisterController.new);
