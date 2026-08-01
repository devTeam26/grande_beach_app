import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../models/home_banner.dart';

class PromotionalBanner extends StatelessWidget {
  const PromotionalBanner({
    super.key,
    required this.banner,
    required this.isArabic,
    required this.onCtaTap,
    required this.ctaLabel,
  });

  final HomeBanner banner;
  final bool isArabic;
  final VoidCallback onCtaTap;
  final String ctaLabel;

  @override
  Widget build(BuildContext context) {
    final badge = isArabic ? banner.badgeAr : banner.badge;
    final headline = isArabic ? banner.headlineAr : banner.headline;
    final description = isArabic ? banner.descriptionAr : banner.description;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          _BannerImage(imageUrl: banner.imageUrl),
          const _GradientOverlay(),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _BannerContent(
              badge: badge,
              headline: headline,
              description: description,
              ctaLabel: ctaLabel,
              onCtaTap: onCtaTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerImage extends StatelessWidget {
  const _BannerImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: 220,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        height: 220,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      errorWidget: (context, url, error) => Container(
        height: 220,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    );
  }
}

class _GradientOverlay extends StatelessWidget {
  const _GradientOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.25),
              Colors.black.withValues(alpha: 0.82),
            ],
            stops: const [0.25, 0.55, 1.0],
          ),
        ),
      ),
    );
  }
}

class _BannerContent extends StatelessWidget {
  const _BannerContent({
    required this.badge,
    required this.headline,
    required this.description,
    required this.ctaLabel,
    required this.onCtaTap,
  });

  final String badge;
  final String headline;
  final String description;
  final String ctaLabel;
  final VoidCallback onCtaTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // _BadgePill(text: badge),
              // const SizedBox(height: 8),
              Text(
                headline,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _CtaButton(label: ctaLabel, onTap: onCtaTap),
      ],
    );
  }
}

class _BadgePill extends StatelessWidget {
  const _BadgePill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryGold,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  const _CtaButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
