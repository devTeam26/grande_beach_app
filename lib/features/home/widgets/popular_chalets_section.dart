import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/home_providers.dart';
import 'chalet_card.dart';
import 'home_skeletons.dart';

class PopularChaletsSection extends ConsumerWidget {
  const PopularChaletsSection({super.key, required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chaletsAsync = ref.watch(popularChaletsProvider);

    return chaletsAsync.when(
      data: (chalets) {
        if (chalets.isEmpty) return const HorizontalChaletListSkeleton();
        return SizedBox(
          height: 270,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: chalets.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) => ChaletCard(
              chalet: chalets[index],
              isArabic: isArabic,
              onTap: () => context.push('/chalet-details/${chalets[index].id}'),
            ),
          ),
        );
      },
      loading: () => const HorizontalChaletListSkeleton(),
      error: (_, _) => const HorizontalChaletListSkeleton(),
    );
  }
}
