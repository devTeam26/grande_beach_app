import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../repositories/auth_repository.dart';
import '../repositories/auth_repository_impl.dart';
import '../services/auth_service.dart';
import '../services/auth_service_impl.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthServiceImpl(ref.watch(apiClientProvider).dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    authService: ref.watch(authServiceProvider),
    networkInfo: ref.watch(networkInfoProvider),
    secureStorage: ref.watch(secureStorageServiceProvider),
    localStorage: ref.watch(localStorageServiceProvider),
  );
});

/// Whether the user currently has a persisted, valid session.
/// Used by the router guard to decide whether to land on Login or Home.
final hasActiveSessionProvider = FutureProvider<bool>((ref) {
  return ref.watch(authRepositoryProvider).hasActiveSession();
});
