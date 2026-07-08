import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/navigation/nav_controller.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/common_header.dart';
import '../../../core/widgets/empty_state.dart';
import '../../home/controllers/home_providers.dart';
import '../widgets/wishlist_chalet_tile.dart';

/// Shows every chalet the user has marked as favorite via the heart icon on
/// [ChaletCard]. Favorited ids are read from [favoritesProvider] (Hive) and
/// each is resolved to its full [Chalet] through [chaletDetailsProvider].
class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isArabic = ref.watch(localeProvider).languageCode == 'ar';
    final favoriteIds = ref.watch(favoritesProvider).toList();

    return Scaffold(
      body: Column(
        children: [
          CommonHeader(
            title: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.wishlist,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: favoriteIds.isEmpty
                ? Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          EmptyState(
                            title: l10n.wishlistEmptyTitle,
                            subtitle: l10n.wishlistEmptySubtitle,
                            icon: Icons.favorite_border_rounded,
                          ),
                          AppButton(
                            label: l10n.exploreChalets,
                            onPressed: () {
                              ref.read(navControllerProvider.notifier).setTab(1);
                              context.pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: favoriteIds.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) => WishlistChaletTile(
                      chaletId: favoriteIds[index],
                      isArabic: isArabic,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
