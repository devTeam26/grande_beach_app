import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../models/user_model.dart';
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

/// Synchronous session flag.
/// Seeded from secure storage before [runApp] and set to [true] immediately
/// on login success / [false] on logout, so the router redirect never needs
/// to wait for an async re-read.
final sessionActiveProvider = StateProvider<bool>((ref) => false);

/// Whether the user currently has a persisted, valid session.
/// Still used for the initial async check on cold start.
final hasActiveSessionProvider = FutureProvider<bool>((ref) {
  return ref.watch(authRepositoryProvider).hasActiveSession();
});

/// The currently authenticated user read from the Hive profile cache.
/// Returns null when no session exists (e.g. after logout).
final currentUserProvider = Provider<UserModel?>((ref) {
  final json = ref.watch(localStorageServiceProvider).getUserProfile();
  if (json == null) return null;
  return UserModel.fromJson(json);
});
