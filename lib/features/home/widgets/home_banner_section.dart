import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/navigation/nav_controller.dart';
import '../controllers/home_providers.dart';
import 'home_skeletons.dart';
import 'promotional_banner.dart';

class HomeBannerSection extends ConsumerWidget {
  const HomeBannerSection({super.key, required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bannersAsync = ref.watch(homeBannersProvider);

    return bannersAsync.when(
      data: (banners) {
        if (banners.isEmpty) return const BannerSkeleton();
        return PromotionalBanner(
          banner: banners.first,
          isArabic: isArabic,
          ctaLabel: l10n.exploreMore,
          onCtaTap: () =>
              ref.read(navControllerProvider.notifier).setTab(1),
        );
      },
      loading: () => const BannerSkeleton(),
      error: (_, _) => const BannerSkeleton(),
    );
  }
}
