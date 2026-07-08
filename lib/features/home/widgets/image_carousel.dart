import 'package:flutter/material.dart';
import 'package:grande_beach/core/config/images.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/network_or_asset_image.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({
    super.key,
    required this.imageUrls,
    required this.height,
  });

  final List<String> imageUrls;
  final double height;

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentPage = 0;
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
if (widget.imageUrls.isEmpty) {
  return SizedBox(
    height: widget.height,
    width: double.infinity,
    child: ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Image.asset(
        AppImages.chaletPlaceholder,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    ),
  );
}

    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.imageUrls.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) =>
                _CarouselImage(url: widget.imageUrls[index]),
          ),
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: _IndicatorDots(
                count: widget.imageUrls.length,
                current: _currentPage,
              ),
            ),
        ],
      ),
    );
  }
}

class _CarouselImage extends StatelessWidget {
  const _CarouselImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return NetworkOrAssetImage(url: url, width: double.infinity);
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
            color: isActive
                ? AppColors.primaryGold
                : Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
