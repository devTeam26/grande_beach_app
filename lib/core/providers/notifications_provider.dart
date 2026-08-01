import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core_providers.dart';

class NotificationsNotifier extends Notifier<bool> {
  @override
  bool build() {
    return ref.watch(localStorageServiceProvider).isNotificationsEnabled();
  }

  Future<void> toggle() async {
    final next = !state;
    await ref
        .read(localStorageServiceProvider)
        .setNotificationsEnabled(next);
    state = next;
  }
}

final notificationsProvider = NotifierProvider<NotificationsNotifier, bool>(
  NotificationsNotifier.new,
);
