import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../home/models/amenity.dart';
import 'amenity_tile.dart';

class ChaletAmenitiesSection extends StatelessWidget {
  const ChaletAmenitiesSection({
    super.key,
    required this.amenities,
    required this.isArabic,
  });

  final List<Amenity> amenities;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    if (amenities.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.amenities,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: amenities
              .map((amenity) => AmenityTile(amenity: amenity, isArabic: isArabic))
              .toList(),
        ),
      ],
    );
  }
}
