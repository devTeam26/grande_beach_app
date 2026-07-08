import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../repositories/profile_repository.dart';
import '../repositories/profile_repository_impl.dart';
import '../services/profile_service.dart';
import '../services/profile_service_impl.dart';

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileServiceImpl(ref.watch(apiClientProvider).dio);
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    profileService: ref.watch(profileServiceProvider),
    networkInfo: ref.watch(networkInfoProvider),
    localStorage: ref.watch(localStorageServiceProvider),
  );
});
