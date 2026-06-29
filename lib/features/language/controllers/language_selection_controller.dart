import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/onboarding_provider.dart';

/// Confirms the user's chosen language: persists + applies the locale and
/// marks the language-selection step as complete.
class LanguageSelectionController extends Notifier<void> {
  @override
  void build() {}

  Future<void> confirm(Locale locale) async {
    await ref.read(localeProvider.notifier).setLocale(locale);
    ref.read(languageSelectedProvider.notifier).markSelected();
  }
}

final languageSelectionControllerProvider =
    NotifierProvider<LanguageSelectionController, void>(
  LanguageSelectionController.new,
);
