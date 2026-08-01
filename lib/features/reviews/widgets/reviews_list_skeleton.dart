import 'package:flutter/material.dart';

import '../../../core/widgets/shimmer_box.dart';

/// Loading placeholder mirroring [ReviewCard]'s layout.
class ReviewsListSkeleton extends StatelessWidget {
  const ReviewsListSkeleton({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AppShimmer(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      SkeletonBox(height: 14, width: 120),
                      SkeletonBox(height: 12, width: 70),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const SkeletonBox(height: 14, width: 100),
                  const SizedBox(height: 10),
                  const SkeletonBox(height: 12, width: double.infinity),
                  const SizedBox(height: 6),
                  const SkeletonBox(height: 12, width: 180),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
