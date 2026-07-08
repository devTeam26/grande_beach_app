import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../core/providers/core_providers.dart';
import '../data/home_mock_data.dart';
import '../models/chalet.dart';
import '../models/home_banner.dart';

const _favoritesKey = 'favorite_chalet_ids';

// ---------------------------------------------------------------------------
// Data providers — swap Future.value(mock) for an API call when backend ready
// ---------------------------------------------------------------------------

final homeBannersProvider = FutureProvider<List<HomeBanner>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 800));
  return HomeMockData.getBanners();
});

final popularChaletsProvider = FutureProvider<List<Chalet>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 900));
  return HomeMockData.getPopularChalets();
});

final recentlyAddedProvider = FutureProvider<List<Chalet>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 900));
  return HomeMockData.getRecentlyAdded();
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
