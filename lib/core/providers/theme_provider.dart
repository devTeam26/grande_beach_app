import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core_providers.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final isDark = ref.watch(localStorageServiceProvider).isDarkModeEnabled();
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggle() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await ref
        .read(localStorageServiceProvider)
        .setDarkModeEnabled(next == ThemeMode.dark);
    state = next;
  }
}

final themeModeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);
