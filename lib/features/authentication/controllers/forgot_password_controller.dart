import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';
import 'auth_providers.dart';

/// Drives the forgot-password screen. State is [AsyncLoading] while the
/// request is in flight, [AsyncError] holding a [Failure] on
/// validation/network/server errors, and [AsyncData] holding the backend's
/// confirmation message (possibly empty) once the reset email is requested.
/// The initial state is `AsyncData(null)`.
class ForgotPasswordController extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async => null;

  Future<void> sendResetEmail({required String email}) async {
    final validationFailure = _validate(email: email);
    if (validationFailure != null) {
      state = AsyncError(validationFailure, StackTrace.current);
      return;
    }

    state = const AsyncLoading();
    final result = await ref
        .read(authRepositoryProvider)
        .forgotPassword(email: email.trim());

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      AsyncData.new,
    );
  }

  Failure? _validate({required String email}) {
    final l10n = lookupAppLocalizations(ref.read(localeProvider));
    final fieldErrors = <String, List<String>>{};

    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      fieldErrors['email'] = [l10n.errorEmailRequired];
    } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(trimmedEmail)) {
      fieldErrors['email'] = [l10n.errorEmailInvalid];
    }

    if (fieldErrors.isEmpty) return null;
    return ValidationFailure(
      fieldErrors.values.first.first,
      fieldErrors: fieldErrors,
    );
  }
}

final forgotPasswordControllerProvider =
    AsyncNotifierProvider<ForgotPasswordController, String?>(
      ForgotPasswordController.new,
    );
