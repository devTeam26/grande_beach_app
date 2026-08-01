import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core_providers.dart';

/// Whether the user has already been shown the onboarding flow.
class OnboardingNotifier extends Notifier<bool> {
  @override
  bool build() {
    final done = ref.watch(localStorageServiceProvider).isOnboardingComplete();
    debugPrint('[AUTH] onboardingProvider: initial state = $done');
    return done;
  }

  Future<void> complete() async {
    await ref.read(localStorageServiceProvider).setOnboardingComplete();
    debugPrint('[AUTH] onboardingProvider: marked complete');
    state = true;
  }
}

final onboardingProvider = NotifierProvider<OnboardingNotifier, bool>(
  OnboardingNotifier.new,
);

/// Whether the language-selection bottom sheet has already been completed.
class LanguageSelectedNotifier extends Notifier<bool> {
  @override
  bool build() {
    final done = ref.watch(localStorageServiceProvider).hasSelectedLanguage();
    debugPrint('[AUTH] languageSelectedProvider: initial state = $done');
    return done;
  }

  void markSelected() {
    debugPrint('[AUTH] languageSelectedProvider: marked selected');
    state = true;
  }
}

final languageSelectedProvider = NotifierProvider<LanguageSelectedNotifier, bool>(
  LanguageSelectedNotifier.new,
);
