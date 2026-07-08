import 'package:flutter/material.dart';

import '../../../core/widgets/shimmer_box.dart';

/// Receipt-like skeleton shown while the booking details are loading:
/// header card, info rows, payment rows, and the button.
class BookingDetailsSkeleton extends StatelessWidget {
  const BookingDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SkeletonBox(height: 64, width: double.infinity, borderRadius: 16),
          const SizedBox(height: 20),
          _sectionSkeleton(rowCount: 5),
          const Divider(height: 40),
          _sectionSkeleton(rowCount: 3),
          const Divider(height: 40),
          _sectionSkeleton(rowCount: 4),
          const SizedBox(height: 24),
          const SkeletonBox(height: 52, width: double.infinity, borderRadius: 26),
        ],
      ),
    );
  }

  Widget _sectionSkeleton({required int rowCount}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SkeletonBox(height: 16, width: 140, borderRadius: 4),
        const SizedBox(height: 14),
        for (var i = 0; i < rowCount; i++) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              SkeletonBox(height: 12, width: 90, borderRadius: 4),
              SkeletonBox(height: 12, width: 70, borderRadius: 4),
            ],
          ),
          if (i != rowCount - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}
