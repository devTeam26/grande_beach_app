import 'package:flutter/material.dart';

import '../../../core/widgets/shimmer_box.dart';

/// Loading placeholder for step 2's add-on list.
class AddOnsListSkeleton extends StatelessWidget {
  const AddOnsListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: List.generate(
            4,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SkeletonBox(height: 72, width: double.infinity, borderRadius: 14),
            ),
          ),
        ),
      ),
    );
  }
}
