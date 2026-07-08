import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/connectivity_status_provider.dart';
import 'no_internet_view.dart';

/// Wraps the entire routed app (mounted via `MaterialApp.router`'s
/// `builder`). Overlays [NoInternetView] on top of the current screen
/// whenever connectivity is lost, without unmounting the navigator
/// underneath — so navigation state and in-flight screens are preserved
/// and the app resumes normally as soon as connectivity returns.
class ConnectivityListener extends ConsumerWidget {
  const ConnectivityListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);

    return Stack(
      children: [
        child,
        if (!isOnline)
          Positioned.fill(
            child: NoInternetView(
              onRetry: () => ref.read(isOnlineProvider.notifier).retry(),
            ),
          ),
      ],
    );
  }
}
