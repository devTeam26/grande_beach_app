import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core_providers.dart';

/// Holds the app's current locale, backed by Hive for persistence.
/// Defaults to English until the user picks a language on first launch.
class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final code = ref.watch(localStorageServiceProvider).getLanguageCode();
    return Locale(code ?? 'en');
  }

  Future<void> setLocale(Locale locale) async {
    await ref
        .read(localStorageServiceProvider)
        .setLanguageCode(locale.languageCode);
    state = locale;
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
