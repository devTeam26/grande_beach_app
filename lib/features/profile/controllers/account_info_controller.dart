import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';
import '../../authentication/controllers/auth_providers.dart';
import '../../authentication/models/user_model.dart';
import '../providers/profile_providers.dart';

class AccountInfoController extends AsyncNotifier<UserModel> {
  @override
  Future<UserModel> build() async {
    // Seed immediately with cached data so the screen renders without a flash.
    final cached = ref.read(currentUserProvider);
    if (cached != null) {
      // Fetch fresh in the background; update state when it arrives.
      _refreshInBackground();
      return cached;
    }
    // No cache: fetch from API.
    final result = await ref.read(profileRepositoryProvider).getProfile();
    return result.fold(
      (failure) => throw failure,
      (user) => user,
    );
  }

  void _refreshInBackground() {
    ref.read(profileRepositoryProvider).getProfile().then((result) {
      result.fold(
        (_) {},
        (user) {
          if (state is AsyncData) state = AsyncData(user);
        },
      );
    });
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    final current = state.valueOrNull;
    if (current == null) return;

    state = const AsyncLoading();
    final result = await ref.read(profileRepositoryProvider).updateProfile(
          firstName: firstName.trim(),
          lastName: lastName.trim(),
          phoneNumber: phoneNumber.trim(),
          preferredLanguage: current.preferredLanguage,
        );

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (updatedUser) {
        ref.invalidate(currentUserProvider);
        return AsyncData(updatedUser);
      },
    );
  }

  Failure? validate({
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) {
    final l10n = lookupAppLocalizations(ref.read(localeProvider));
    final errors = <String, List<String>>{};

    if (firstName.trim().isEmpty) {
      errors['firstName'] = [l10n.errorFirstNameRequired];
    }
    if (lastName.trim().isEmpty) {
      errors['lastName'] = [l10n.errorLastNameRequired];
    }
    if (phoneNumber.trim().isEmpty) {
      errors['phoneNumber'] = [l10n.errorPhoneRequired];
    }

    if (errors.isEmpty) return null;
    return ValidationFailure(
      errors.values.first.first,
      fieldErrors: errors,
    );
  }
}

final accountInfoControllerProvider =
    AsyncNotifierProvider<AccountInfoController, UserModel>(
  AccountInfoController.new,
);
