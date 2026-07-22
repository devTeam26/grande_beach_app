import 'package:flutter/material.dart';

import '../../../core/widgets/shimmer_box.dart';

/// Loading placeholder for step 3's price breakdown card.
class PriceBreakdownSkeleton extends StatelessWidget {
  const PriceBreakdownSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SkeletonBox(height: 20, width: 140),
            const SizedBox(height: 16),
            for (var i = 0; i < 4; i++) ...[
              SkeletonBox(height: 16, width: double.infinity),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}
