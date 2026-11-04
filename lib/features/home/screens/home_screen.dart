import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grande_beach/core/config/app_icons.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/widgets/common_header.dart';
import '../../authentication/controllers/auth_providers.dart';
import '../controllers/home_providers.dart';
import '../widgets/home_banner_section.dart';
import '../widgets/popular_chalets_section.dart';
import '../widgets/recently_added_section.dart';
import '../widgets/section_header.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final hasSession = ref.watch(sessionActiveProvider);
    // Guests (no session) are greeted as "Guest", never by a cached name.
    final greetingName = hasSession
        ? ref.watch(currentUserProvider)?.firstName ?? ''
        : l10n.guest;
    final isArabic = ref.watch(localeProvider).languageCode == 'ar';

    return Scaffold(
      body: Column(
        children: [
          CommonHeader(
            bottomHeight: 20,
            title: Row(
              children: [
                const Icon(AppIcons.home, size: 22, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  l10n.greeting(greetingName),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => Future.wait([
                ref.refresh(homeBannersProvider.future),
                ref.refresh(popularChaletsProvider.future),
                ref.refresh(recentlyAddedProvider.future),
              ]),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeBannerSection(isArabic: isArabic),
                    const SizedBox(height: 28),
                    SectionHeader(title: l10n.popularChalets, onSeeAll: () {}),
                    const SizedBox(height: 14),
                    PopularChaletsSection(isArabic: isArabic),
                    const SizedBox(height: 28),
                    SectionHeader(title: l10n.recentlyAdded, onSeeAll: () {}),
                    const SizedBox(height: 14),
                    RecentlyAddedSection(isArabic: isArabic),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
