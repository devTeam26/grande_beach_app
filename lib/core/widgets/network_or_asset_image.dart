import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Renders [url] via [CachedNetworkImage], or [Image.asset] when it points
/// at a bundled asset (`assets/...`). Shared by anything that displays a
/// chalet image — cards, carousels, the details gallery, and the viewer.
class NetworkOrAssetImage extends StatelessWidget {
  const NetworkOrAssetImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (url.startsWith('assets/')) {
      return Image.asset(url, width: width, height: height, fit: fit);
    }
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      errorWidget: (context, url, error) => ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    );
  }
}
