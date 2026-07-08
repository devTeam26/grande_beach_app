import 'package:flutter/material.dart';

import '../../../core/widgets/shimmer_box.dart';
import 'chalet_image_gallery.dart';

/// Loading placeholder mirroring the details screen layout: image slider,
/// title, rating, description, and amenities.
class ChaletDetailsSkeleton extends StatelessWidget {
  const ChaletDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppShimmer(
            child: SkeletonBox(
              height: ChaletImageGallery.height,
              width: double.infinity,
              borderRadius: 0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: AppShimmer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonBox(height: 22, width: 200),
                  const SizedBox(height: 10),
                  const SkeletonBox(height: 14, width: 150),
                  const SizedBox(height: 20),
                  const SkeletonBox(height: 16, width: 120),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      3,
                      (index) => const Column(
                        children: [
                          SkeletonBox(height: 52, width: 52, borderRadius: 14),
                          SizedBox(height: 8),
                          SkeletonBox(height: 12, width: 70),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SkeletonBox(height: 16, width: 140),
                  const SizedBox(height: 10),
                  const SkeletonBox(height: 12, width: double.infinity),
                  const SizedBox(height: 8),
                  const SkeletonBox(height: 12, width: double.infinity),
                  const SizedBox(height: 8),
                  const SkeletonBox(height: 12, width: 220),
                  const SizedBox(height: 24),
                  const SkeletonBox(height: 16, width: 100),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      6,
                      (index) => const SkeletonBox(
                        height: 38,
                        width: 100,
                        borderRadius: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
