import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/images.dart';
import '../../../core/widgets/network_or_asset_image.dart';
import '../../home/controllers/home_providers.dart';
import '../screens/chalet_image_viewer_screen.dart';

/// Hero image section: swipeable gallery, page indicator, back and favorite
/// buttons floating on top, tap-to-zoom into the full-screen viewer.
class ChaletImageGallery extends StatefulWidget {
  const ChaletImageGallery({
    super.key,
    required this.chaletId,
    required this.imageUrls,
  });

  final String chaletId;
  final List<String> imageUrls;

  static const double height = 340;

  @override
  State<ChaletImageGallery> createState() => _ChaletImageGalleryState();
}

class _ChaletImageGalleryState extends State<ChaletImageGallery> {
  final _controller = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _heroTag(int index) => 'chalet_image_${widget.chaletId}_$index';

  void _openViewer(int initialIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        transitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
          opacity: animation,
          child: ChaletImageViewerScreen(
            imageUrls: widget.imageUrls,
            initialIndex: initialIndex,
            heroTagBuilder: _heroTag,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = widget.imageUrls.isNotEmpty;
    final topPadding = MediaQuery.of(context).padding.top + 12;
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
    return SizedBox(
      height: ChaletImageGallery.height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (!hasImages)
            ColoredBox(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const NetworkOrAssetImage(url: AppImages.chaletPlaceholder),
            )
          else
            PageView.builder(
              controller: _controller,
              itemCount: widget.imageUrls.length,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (context, index) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _openViewer(index),
                child: Hero(
                  tag: _heroTag(index),
                  child: NetworkOrAssetImage(url: widget.imageUrls[index]),
                ),
              ),
            ),
          Positioned.directional(
            textDirection: Directionality.of(context),
            top: topPadding,
            start: 16,
            child: _CircleIconButton(
              icon: isAndroid ? Icons.arrow_back : Icons.arrow_back_ios_new,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned.directional(
            textDirection: Directionality.of(context),
            top: topPadding,
            end: 16,
            child: _FavoriteButton(chaletId: widget.chaletId),
          ),
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  _IndicatorDots(
                    count: widget.imageUrls.length,
                    current: _currentIndex,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_currentIndex + 1}/${widget.imageUrls.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

class _FavoriteButton extends ConsumerWidget {
  const _FavoriteButton({required this.chaletId});

  final String chaletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(isFavoriteProvider(chaletId));

    return GestureDetector(
      onTap: () => ref.read(favoritesProvider.notifier).toggle(chaletId),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isFavorite ? Colors.red[400] : Colors.white,
          size: 18,
        ),
      ),
    );
  }
}

class _IndicatorDots extends StatelessWidget {
  const _IndicatorDots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 16 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
