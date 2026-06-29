import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core_providers.dart';

/// Whether the user has already been shown the onboarding flow.
class OnboardingNotifier extends Notifier<bool> {
  @override
  bool build() {
    return ref.watch(localStorageServiceProvider).isOnboardingComplete();
  }

  Future<void> complete() async {
    await ref.read(localStorageServiceProvider).setOnboardingComplete();
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
    return ref.watch(localStorageServiceProvider).hasSelectedLanguage();
  }

  void markSelected() => state = true;
}

final languageSelectedProvider = NotifierProvider<LanguageSelectedNotifier, bool>(
  LanguageSelectedNotifier.new,
);
