import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../config/images.dart';

/// Renders [url] via [CachedNetworkImage], or [Image.asset] when it points
/// at a bundled asset (`assets/...`). Shared by anything that displays a
/// chalet image — cards, carousels, the details gallery, and the viewer.
///
/// Falls back to [AppImages.chaletPlaceholder] for URLs that aren't
/// reachable from the device (e.g. `localhost`/local-network hosts used
/// during backend development) and for any image that fails to load.
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

  static bool _isUnreachableHost(String url) {
    final host = Uri.tryParse(url)?.host ?? '';
    return host == 'localhost' || host == '127.0.0.1' || host == '10.0.2.2';
  }

  @override
  Widget build(BuildContext context) {
    if (url.startsWith('assets/')) {
      return Image.asset(url, width: width, height: height, fit: fit);
    }
    if (_isUnreachableHost(url)) {
      return Image.asset(
        AppImages.chaletPlaceholder,
        width: width,
        height: height,
        fit: fit,
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      errorWidget: (context, url, error) => Image.asset(
        AppImages.chaletPlaceholder,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}
