import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/connectivity_service.dart';
import 'core_providers.dart';

/// Global reactive online/offline flag backed by [ConnectivityService].
/// Starts optimistic (`true`) and corrects itself as soon as the first
/// real check resolves, then stays live for the lifetime of the app so
/// any widget can react to connectivity changes without polling.
class ConnectivityStatusNotifier extends Notifier<bool> {
  StreamSubscription<ConnectivityState>? _subscription;

  @override
  bool build() {
    final service = ref.watch(connectivityServiceProvider);

    _subscription?.cancel();
    _subscription = service.onStateChange.listen((connectivityState) {
      state = connectivityState.isOnline;
    });
    ref.onDispose(() => _subscription?.cancel());

    unawaited(_refresh(service));
    return true;
  }

  Future<void> _refresh(ConnectivityService service) async {
    final result = await service.checkNow();
    state = result.isOnline;
  }

  /// Manually re-checks connectivity, e.g. from the offline screen's
  /// retry button.
  Future<void> retry() => _refresh(ref.read(connectivityServiceProvider));
}

final isOnlineProvider = NotifierProvider<ConnectivityStatusNotifier, bool>(
  ConnectivityStatusNotifier.new,
);
