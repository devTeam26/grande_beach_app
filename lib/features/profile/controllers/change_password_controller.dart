import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';
import '../../authentication/utils/password_policy.dart';
import '../providers/profile_providers.dart';

class ChangePasswordController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final failure = _validate(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    if (failure != null) {
      state = AsyncError(failure, StackTrace.current);
      return;
    }

    state = const AsyncLoading();
    final result = await ref.read(profileRepositoryProvider).changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }

  Failure? _validate({
    required String currentPassword,
    required String newPassword,
  }) {
    final l10n = lookupAppLocalizations(ref.read(localeProvider));
    final errors = <String, List<String>>{};

    if (currentPassword.isEmpty) {
      errors['currentPassword'] = [l10n.errorCurrentPasswordRequired];
    }
    if (newPassword.isEmpty) {
      errors['newPassword'] = [l10n.errorPasswordRequired];
    } else if (!PasswordPolicy.isValid(newPassword)) {
      errors['newPassword'] = [l10n.errorPasswordRequirementsNotMet];
    }

    if (errors.isEmpty) return null;
    return ValidationFailure(
      errors.values.first.first,
      fieldErrors: errors,
    );
  }
}

final changePasswordControllerProvider =
    AsyncNotifierProvider<ChangePasswordController, void>(
  ChangePasswordController.new,
);
