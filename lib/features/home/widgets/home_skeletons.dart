import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BannerSkeleton extends StatelessWidget {
  const BannerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _Shimmer(
      isDark: isDark,
      child: _SkeletonBox(
        height: 220,
        width: double.infinity,
        borderRadius: 16,
      ),
    );
  }
}

class HorizontalChaletListSkeleton extends StatelessWidget {
  const HorizontalChaletListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 270,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: 3,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (_, __) => _Shimmer(
          isDark: isDark,
          child: const _ChaletCardSkeleton(imageHeight: 160, width: 260),
        ),
      ),
    );
  }
}

class VerticalChaletListSkeleton extends StatelessWidget {
  const VerticalChaletListSkeleton({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: List.generate(
        itemCount,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _Shimmer(
            isDark: isDark,
            child: const _ChaletCardSkeleton(imageHeight: 200, width: double.infinity),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Internal helpers
// ---------------------------------------------------------------------------

class _Shimmer extends StatelessWidget {
  const _Shimmer({required this.isDark, required this.child});

  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E0E0),
      highlightColor: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5),
      child: child,
    );
  }
}

class _ChaletCardSkeleton extends StatelessWidget {
  const _ChaletCardSkeleton({
    required this.imageHeight,
    required this.width,
  });

  final double imageHeight;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _SkeletonBox(height: imageHeight, width: double.infinity, borderRadius: 0),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBox(height: 14, width: 150, borderRadius: 4),
                const SizedBox(height: 8),
                _SkeletonBox(height: 12, width: 110, borderRadius: 4),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SkeletonBox(height: 12, width: 90, borderRadius: 4),
                    _SkeletonBox(height: 12, width: 75, borderRadius: 4),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.height,
    required this.width,
    required this.borderRadius,
  });

  final double height;
  final double width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
