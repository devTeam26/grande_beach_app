import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../models/onboarding_page_data.dart';
import 'onboarding_page_indicator.dart';

class OnboardingContentCard extends StatelessWidget {
  const OnboardingContentCard({
    super.key,
    required this.page,
    required this.pageCount,
    required this.currentIndex,
    required this.isLastPage,
    required this.onNext,
    required this.onSkip,
  });

  final OnboardingPageData page;
  final int pageCount;
  final int currentIndex;
  final bool isLastPage;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
       //borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title/description are already baked into the onboarding
          // images, so the text overlay is disabled here.
          // Text(
          //   page.title,
          //   textAlign: TextAlign.center,
          //   style: theme.textTheme.headlineSmall?.copyWith(
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          // const SizedBox(height: 12),
          // Text(
          //   page.description,
          //   textAlign: TextAlign.center,
          //   style: theme.textTheme.bodyMedium,
          // ),
          OnboardingPageIndicator(
            pageCount: pageCount,
            currentIndex: currentIndex,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onNext,
              child: Text(isLastPage ? l10n.getStarted : l10n.next),
            ),
          ),
          if (!isLastPage)
            TextButton(
              onPressed: onSkip,
              child: Text(l10n.skip),
            ),
        ],
      ),
    );
  }
}
