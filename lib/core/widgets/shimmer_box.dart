import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shared shimmer wrapper for skeleton loading states.
class AppShimmer extends StatelessWidget {
  const AppShimmer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E0E0),
      highlightColor: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5),
      child: child,
    );
  }
}

/// A single shimmering placeholder rectangle.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius = 4,
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
