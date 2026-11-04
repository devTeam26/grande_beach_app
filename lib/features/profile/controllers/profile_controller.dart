import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/result.dart';
import '../../../features/authentication/controllers/auth_providers.dart';
import '../../booking/controllers/bookings_providers.dart';
import '../../booking/controllers/verification_providers.dart';

class ProfileController extends AsyncNotifier<void> {
  // Synchronous so the provider starts as AsyncData, not AsyncLoading — an
  // initial loading→data transition would look like a finished request to
  // listeners such as DeleteAccountDialog.
  @override
  FutureOr<void> build() {}

  Future<void> logout() async {
    state = const AsyncLoading();
    final result = await ref.read(authRepositoryProvider).logout();
    _onSessionEnded(result);
  }

  /// Permanently deletes the account. On success the user ends up signed out
  /// exactly as after [logout]; on failure they stay signed in.
  Future<void> deleteAccount() async {
    if (state.isLoading) return;

    state = const AsyncLoading();
    final result = await ref.read(authRepositoryProvider).deleteAccount();
    _onSessionEnded(result);
  }

  void _onSessionEnded(Result<void> result) {
    state = result.fold((failure) => AsyncError(failure, StackTrace.current), (
      _,
    ) {
      ref.read(sessionActiveProvider.notifier).state = false;
      ref.invalidate(currentUserProvider);
      ref.read(verificationRepositoryProvider).clearCache();
      ref.invalidate(verificationStatusProvider);
      // Drop the signed-out user's bookings so they never show for the guest
      // (or the next account) that follows.
      ref.invalidate(bookingsProvider);
      return const AsyncData(null);
    });
  }
}

final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, void>(ProfileController.new);
