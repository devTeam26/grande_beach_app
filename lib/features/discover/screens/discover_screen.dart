import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grande_beach/core/config/app_icons.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/widgets/common_header.dart';
import '../widgets/discover_chalet_list.dart';
import '../widgets/discover_search_bar.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isArabic = ref.watch(localeProvider).languageCode == 'ar';

    return Scaffold(
      body: Column(
        children: [
          CommonHeader(
            bottomHeight: 68,
            title: Row(
              children: [
                const Icon(AppIcons.discover, size: 22, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  l10n.discoverTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(bottom: 8, top: 16),
            child: DiscoverSearchBar(),
          ),
          Expanded(child: DiscoverChaletList(isArabic: isArabic)),
        ],
      ),
    );
  }
}
