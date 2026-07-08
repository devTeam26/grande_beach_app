import 'package:flutter/material.dart';

import '../../../core/widgets/shimmer_box.dart';

/// Skeleton placeholder mirroring [BookingCard]'s layout, shown while the
/// bookings list is loading.
class BookingCardSkeleton extends StatelessWidget {
  const BookingCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppShimmer(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SkeletonBox(height: 84, width: 84, borderRadius: 12),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonBox(height: 16, width: 150, borderRadius: 4),
                  const SizedBox(height: 8),
                  const SkeletonBox(height: 12, width: 100, borderRadius: 4),
                  const SizedBox(height: 8),
                  const SkeletonBox(height: 12, width: 130, borderRadius: 4),
                  const SizedBox(height: 12),
                  SkeletonBox(
                    height: 36,
                    width: double.infinity,
                    borderRadius: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A scrollable list of [BookingCardSkeleton]s.
class BookingsListSkeleton extends StatelessWidget {
  const BookingsListSkeleton({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: const BookingCardSkeleton(),
        ),
      ),
    );
  }
}
