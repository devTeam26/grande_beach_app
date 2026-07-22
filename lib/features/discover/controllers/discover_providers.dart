import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../../home/models/chalet.dart';
import '../models/chalet_filters.dart';
import '../repositories/discover_repository.dart';
import '../repositories/discover_repository_impl.dart';
import '../services/discover_service.dart';
import '../services/discover_service_impl.dart';

const _pageSize = 20;

final discoverServiceProvider = Provider<DiscoverService>((ref) {
  return DiscoverServiceImpl(ref.watch(apiClientProvider).dio);
});

final discoverRepositoryProvider = Provider<DiscoverRepository>((ref) {
  return DiscoverRepositoryImpl(
    discoverService: ref.watch(discoverServiceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

class DiscoverState {
  const DiscoverState({
    required this.chalets,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  final List<Chalet> chalets;
  final bool hasMore;
  final bool isLoadingMore;

  DiscoverState copyWith({
    List<Chalet>? chalets,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return DiscoverState(
      chalets: chalets ?? this.chalets,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Paginated chalet catalog for the Discover tab, backed by /api/Chalets.
class DiscoverChaletsNotifier extends AsyncNotifier<DiscoverState> {
  int _page = 1;
  ChaletFilters _filters = const ChaletFilters.empty();

  @override
  Future<DiscoverState> build() async {
    _page = 1;
    final result = await ref
        .read(discoverRepositoryProvider)
        .fetchChalets(pageNumber: _page, pageSize: _pageSize, filters: _filters);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (page) => DiscoverState(chalets: page.chalets, hasMore: page.hasMore),
    );
  }

  Future<void> loadNextPage() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final nextPage = _page + 1;
    final result = await ref.read(discoverRepositoryProvider).fetchChalets(
          pageNumber: nextPage,
          pageSize: _pageSize,
          filters: _filters,
        );

    result.fold(
      (failure) {
        state = AsyncData(current.copyWith(isLoadingMore: false));
      },
      (page) {
        _page = nextPage;
        state = AsyncData(
          current.copyWith(
            chalets: [...current.chalets, ...page.chalets],
            hasMore: page.hasMore,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  /// Applies new search filters, resetting to page 1 of the filtered results.
  Future<void> applyFilters(ChaletFilters filters) async {
    _filters = filters;
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }

  Future<void> retry() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }

  /// Reloads the first page for pull-to-refresh, keeping the current list
  /// visible (rather than switching to the loading skeleton).
  Future<void> refresh() async {
    final current = state.valueOrNull;
    _page = 1;

    final result = await ref
        .read(discoverRepositoryProvider)
        .fetchChalets(pageNumber: _page, pageSize: _pageSize, filters: _filters);

    result.fold(
      (failure) {
        if (current == null) state = AsyncError(failure, StackTrace.current);
      },
      (page) {
        state = AsyncData(
          DiscoverState(chalets: page.chalets, hasMore: page.hasMore),
        );
      },
    );
  }
}

final discoverChaletsProvider =
    AsyncNotifierProvider<DiscoverChaletsNotifier, DiscoverState>(
  DiscoverChaletsNotifier.new,
);
