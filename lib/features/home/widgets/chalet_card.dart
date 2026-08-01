import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/images.dart';
import '../../../core/widgets/network_or_asset_image.dart';
import '../controllers/home_providers.dart';
import '../models/chalet.dart';
import 'price_widget.dart';
import 'rating_row.dart';

class ChaletCard extends StatelessWidget {
  const ChaletCard({
    super.key,
    required this.chalet,
    required this.isArabic,
    this.isFullWidth = false,
    this.onTap,
  });

  final Chalet chalet;
  final bool isArabic;
  final bool isFullWidth;
  final VoidCallback? onTap;

  static const double _cardWidth = 260;
  static const double _carouselHeightNarrow = 160;
  static const double _carouselHeightFull = 200;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = isArabic ? chalet.nameAr : chalet.name;
    final location = (isArabic ? chalet.locationAr : chalet.location) ??
        chalet.location;
    final imageUrl = chalet.primaryImageUrl;
    final carouselHeight =
        isFullWidth ? _carouselHeightFull : _carouselHeightNarrow;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isFullWidth ? double.infinity : _cardWidth,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: carouselHeight,
                    width: double.infinity,
                    child: NetworkOrAssetImage(
                      url: (imageUrl == null || imageUrl.isEmpty)
                          ? AppImages.chaletPlaceholder
                          : imageUrl,
                      width: double.infinity,
                      height: carouselHeight,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _FavoriteButton(chaletId: chalet.id),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    _LocationRow(location: location, theme: theme),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingRow(
                          rating: chalet.averageRating,
                          totalReviews: chalet.totalReviews,
                        ),
                        PriceWidget(price: chalet.basePrice),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  const _LocationRow({required this.location, required this.theme});

  final String location;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final subtleColor = theme.colorScheme.onSurface.withValues(alpha: 0.5);
    return Row(
      children: [
        Icon(Icons.location_on_outlined, size: 13, color: subtleColor),
        const SizedBox(width: 2),
        Expanded(
          child: Text(
            location,
            style: TextStyle(fontSize: 12, color: subtleColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.28),
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
