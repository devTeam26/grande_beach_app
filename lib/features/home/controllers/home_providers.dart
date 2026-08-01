import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../core/providers/core_providers.dart';
import '../data/home_mock_data.dart';
import '../models/chalet.dart';
import '../models/home_banner.dart';
import '../repositories/home_repository.dart';
import '../repositories/home_repository_impl.dart';
import '../services/home_service.dart';
import '../services/home_service_impl.dart';

const _favoritesKey = 'favorite_chalet_ids';

// ---------------------------------------------------------------------------
// Dependency injection
// ---------------------------------------------------------------------------

final homeServiceProvider = Provider<HomeService>((ref) {
  return HomeServiceImpl(ref.watch(apiClientProvider).dio);
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(
    homeService: ref.watch(homeServiceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

// ---------------------------------------------------------------------------
// Data providers
// ---------------------------------------------------------------------------

// TODO(backend): replace with a banners endpoint when available.
final homeBannersProvider = FutureProvider<List<HomeBanner>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 800));
  return HomeMockData.getBanners();
});

final popularChaletsProvider = FutureProvider<List<Chalet>>((ref) async {
  final result = await ref.watch(homeRepositoryProvider).fetchPopularChalets();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (chalets) => chalets,
  );
});

final recentlyAddedProvider = FutureProvider<List<Chalet>>((ref) async {
  final result =
      await ref.watch(homeRepositoryProvider).fetchRecentlyAddedChalets();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (chalets) => chalets,
  );
});

// ---------------------------------------------------------------------------
// Favorites — persisted to Hive, shared with the Wishlist screen
// ---------------------------------------------------------------------------

class FavoritesNotifier extends Notifier<Set<String>> {
  late Box _box;

  @override
  Set<String> build() {
    _box = ref.watch(hiveBoxProvider);
    final raw = _box.get(_favoritesKey);
    if (raw == null) return {};
    return Set<String>.from((raw as List).cast<String>());
  }

  Future<void> toggle(String chaletId) async {
    final updated = Set<String>.from(state);
    if (updated.contains(chaletId)) {
      updated.remove(chaletId);
    } else {
      updated.add(chaletId);
    }
    state = updated;
    await _box.put(_favoritesKey, updated.toList());
  }
}

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, Set<String>>(FavoritesNotifier.new);

/// Derived provider — avoids rebuilding the full favorites set on every widget.
final isFavoriteProvider = Provider.family<bool, String>((ref, chaletId) {
  return ref.watch(favoritesProvider).contains(chaletId);
});
