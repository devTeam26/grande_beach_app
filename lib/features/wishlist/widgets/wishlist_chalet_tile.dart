import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/error_state.dart';
import '../../chalet_details/controllers/chalet_details_providers.dart';
import '../../home/widgets/chalet_card.dart';
import '../../home/widgets/home_skeletons.dart';

/// Resolves a single favorited chalet id to its full [Chalet] and renders it
/// as a [ChaletCard]. Fetched (and cached) via the same provider used by the
/// Chalet Details screen, so no separate "list favorites" endpoint is needed.
class WishlistChaletTile extends ConsumerWidget {
  const WishlistChaletTile({
    super.key,
    required this.chaletId,
    required this.isArabic,
  });

  final String chaletId;
  final bool isArabic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final chaletAsync = ref.watch(chaletDetailsProvider(chaletId));

    return chaletAsync.when(
      loading: () => const VerticalChaletListSkeleton(itemCount: 1),
      error: (_, _) => ErrorState(
        message: l10n.errorLoadingChalets,
        onRetry: () => ref.invalidate(chaletDetailsProvider(chaletId)),
      ),
      data: (chalet) => ChaletCard(
        chalet: chalet,
        isArabic: isArabic,
        isFullWidth: true,
        onTap: () => context.push('/chalet-details/${chalet.id}'),
      ),
    );
  }
}
