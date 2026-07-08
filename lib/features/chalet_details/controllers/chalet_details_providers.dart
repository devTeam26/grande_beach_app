import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../../home/models/chalet.dart';
import '../repositories/chalet_details_repository.dart';
import '../repositories/chalet_details_repository_impl.dart';
import '../services/chalet_details_service.dart';
import '../services/chalet_details_service_impl.dart';

final chaletDetailsServiceProvider = Provider<ChaletDetailsService>((ref) {
  return ChaletDetailsServiceImpl(ref.watch(apiClientProvider).dio);
});

final chaletDetailsRepositoryProvider = Provider<ChaletDetailsRepository>((ref) {
  return ChaletDetailsRepositoryImpl(
    chaletDetailsService: ref.watch(chaletDetailsServiceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

/// Fetches a single chalet by id for the details screen.
final chaletDetailsProvider =
    FutureProvider.family<Chalet, String>((ref, id) async {
  final result = await ref.watch(chaletDetailsRepositoryProvider).fetchChaletById(id);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (chalet) => chalet,
  );
});
