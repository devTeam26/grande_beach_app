import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/authentication/controllers/auth_providers.dart';

class ProfileController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> logout() async {
    state = const AsyncLoading();
    final result = await ref.read(authRepositoryProvider).logout();
    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (_) {
        ref.read(sessionActiveProvider.notifier).state = false;
        ref.invalidate(currentUserProvider);
        return const AsyncData(null);
      },
    );
  }
}

final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, void>(ProfileController.new);
