import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';
import '../../booking/controllers/verification_providers.dart';
import 'auth_providers.dart';

/// Drives the login screen. State is [AsyncLoading] while signing in,
/// [AsyncError] holding a [Failure] on validation/network/server errors,
/// and [AsyncData] on success.
class LoginController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> login({required String email, required String password}) async {
    final validationFailure = _validate(email: email, password: password);
    if (validationFailure != null) {
      state = AsyncError(validationFailure, StackTrace.current);
      return;
    }

    state = const AsyncLoading();
    final result = await ref.read(authRepositoryProvider).login(
          email: email.trim(),
          password: password,
        );

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (_) {
        // Set sync flag first so the router redirect sees the new session state
        // on the very next frame, before any async re-read completes.
        ref.read(sessionActiveProvider.notifier).state = true;
        ref.invalidate(currentUserProvider);
        // Populates the verification status cache once for this session;
        // `getStatus()` inside its build() will hit the network only because
        // the cache was cleared on the previous logout.
        ref.invalidate(verificationStatusProvider);
        return const AsyncData(null);
      },
    );
  }

  Failure? _validate({required String email, required String password}) {
    final l10n = lookupAppLocalizations(ref.read(localeProvider));
    final trimmedEmail = email.trim();
    final fieldErrors = <String, List<String>>{};

    if (trimmedEmail.isEmpty) {
      fieldErrors['email'] = [l10n.errorEmailRequired];
    } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(trimmedEmail)) {
      fieldErrors['email'] = [l10n.errorEmailInvalid];
    }

    if (password.isEmpty) {
      fieldErrors['password'] = [l10n.errorPasswordRequired];
    } else if (password.length < 6) {
      fieldErrors['password'] = [l10n.errorPasswordTooShort];
    }

    if (fieldErrors.isEmpty) return null;
    return ValidationFailure(
      fieldErrors.values.first.first,
      fieldErrors: fieldErrors,
    );
  }
}

final loginControllerProvider =
    AsyncNotifierProvider<LoginController, void>(LoginController.new);
