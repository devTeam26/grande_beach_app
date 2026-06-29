import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks which onboarding page is currently visible.
class OnboardingPageIndexController extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

final onboardingPageIndexProvider =
    NotifierProvider<OnboardingPageIndexController, int>(
  OnboardingPageIndexController.new,
);
