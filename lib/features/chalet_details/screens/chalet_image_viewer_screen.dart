import 'package:flutter/material.dart';

import '../../../core/widgets/network_or_asset_image.dart';

/// Full-screen image viewer opened by tapping a gallery image.
/// Supports pinch-to-zoom, double-tap zoom, swipe between images, and
/// panning while zoomed. Opens/closes with a Hero flight matching the
/// tapped gallery image.
class ChaletImageViewerScreen extends StatefulWidget {
  const ChaletImageViewerScreen({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
    required this.heroTagBuilder,
  });

  final List<String> imageUrls;
  final int initialIndex;
  final String Function(int index) heroTagBuilder;

  @override
  State<ChaletImageViewerScreen> createState() => _ChaletImageViewerScreenState();
}

class _ChaletImageViewerScreenState extends State<ChaletImageViewerScreen> {
  late final PageController _controller =
      PageController(initialPage: widget.initialIndex);
  late int _currentIndex = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.imageUrls.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (context, index) => Hero(
              tag: widget.heroTagBuilder(index),
              child: _ZoomableImage(url: widget.imageUrls[index]),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close_rounded, color: Colors.white),
              ),
            ),
          ),
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 16,
              left: 0,
              right: 0,
              child: Text(
                '${_currentIndex + 1}/${widget.imageUrls.length}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ZoomableImage extends StatefulWidget {
  const _ZoomableImage({required this.url});

  final String url;

  @override
  State<_ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<_ZoomableImage>
    with SingleTickerProviderStateMixin {
  final _transformationController = TransformationController();
  TapDownDetails? _doubleTapDetails;
  late final AnimationController _animController;
  Animation<Matrix4>? _animation;

  static const double _zoomScale = 3;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        if (_animation != null) {
          _transformationController.value = _animation!.value;
        }
      });
  }

  @override
  void dispose() {
    _animController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _onDoubleTapDown(TapDownDetails details) => _doubleTapDetails = details;

  void _onDoubleTap() {
    final isZoomedIn = _transformationController.value != Matrix4.identity();
    final endMatrix = isZoomedIn ? Matrix4.identity() : _zoomedMatrix();

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: endMatrix,
    ).animate(CurveTween(curve: Curves.easeOut).animate(_animController));
    _animController.forward(from: 0);
  }

  Matrix4 _zoomedMatrix() {
    final position = _doubleTapDetails?.localPosition ?? Offset.zero;
    return Matrix4.identity()
      ..translateByDouble(
        -position.dx * (_zoomScale - 1),
        -position.dy * (_zoomScale - 1),
        0,
        1,
      )
      ..scaleByDouble(_zoomScale, _zoomScale, _zoomScale, 1);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: _onDoubleTapDown,
      onDoubleTap: _onDoubleTap,
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: 1,
        maxScale: 4,
        child: Center(
          child: NetworkOrAssetImage(
            url: widget.url,
            fit: BoxFit.contain,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
