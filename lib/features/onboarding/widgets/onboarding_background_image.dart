import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class OnboardingBackgroundImage extends StatelessWidget {
  const OnboardingBackgroundImage({super.key, required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = assetPath.startsWith('http');
    return SizedBox.expand(
      child: isNetworkImage
          ? CachedNetworkImage(
              imageUrl: assetPath,
              fit: BoxFit.contain ,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.surface,
                highlightColor: Theme.of(context).dividerColor,
                child: Container(color: Theme.of(context).colorScheme.surface),
              ),
            )
          : Image.asset(assetPath, fit: BoxFit.cover),
    );
  }
}
