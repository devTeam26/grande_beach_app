import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/images.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/providers/onboarding_provider.dart';
import '../controllers/onboarding_page_index_controller.dart';
import '../models/onboarding_page_data.dart';
import '../widgets/onboarding_background_image.dart';
import '../widgets/onboarding_content_card.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finishOnboarding() {
    ref.read(onboardingProvider.notifier).complete();
    context.go('/login');
  }

  void _goToNext(int pageCount) {
    final currentIndex = ref.read(onboardingPageIndexProvider);
    if (currentIndex == pageCount - 1) {
      _finishOnboarding();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = [
      OnboardingPageData(
        imagePath: AppImages.onboarding1,
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDescription1,
      ),
      OnboardingPageData(
        imagePath: AppImages.onboarding2,
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDescription2,
      ),
      OnboardingPageData(
        imagePath: AppImages.onboarding3,
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDescription3,
      ),
    ];
    final currentIndex = ref.watch(onboardingPageIndexProvider);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            bottom: MediaQuery.of(context).size.height * 0.32,
            child: PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              onPageChanged: (index) => ref
                  .read(onboardingPageIndexProvider.notifier)
                  .setIndex(index),
              itemBuilder: (context, index) {
                return OnboardingBackgroundImage(
                  assetPath: pages[index].imagePath,
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: OnboardingContentCard(
              page: pages[currentIndex],
              pageCount: pages.length,
              currentIndex: currentIndex,
              isLastPage: currentIndex == pages.length - 1,
              onNext: () => _goToNext(pages.length),
              onSkip: _finishOnboarding,
            ),
          ),
        ],
      ),
    );
  }
}
