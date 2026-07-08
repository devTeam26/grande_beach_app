import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/home_providers.dart';
import 'chalet_card.dart';
import 'home_skeletons.dart';

class RecentlyAddedSection extends ConsumerWidget {
  const RecentlyAddedSection({super.key, required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chaletsAsync = ref.watch(recentlyAddedProvider);

    return chaletsAsync.when(
      data: (chalets) {
        if (chalets.isEmpty) return const VerticalChaletListSkeleton();
        return Column(
          children: chalets
              .map(
                (c) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ChaletCard(
                    chalet: c,
                    isArabic: isArabic,
                    isFullWidth: true,
                    onTap: () => context.push('/chalet-details/${c.id}'),
                  ),
                ),
              )
              .toList(),
        );
      },
      loading: () => const VerticalChaletListSkeleton(),
      error: (_, _) => const VerticalChaletListSkeleton(),
    );
  }
}
