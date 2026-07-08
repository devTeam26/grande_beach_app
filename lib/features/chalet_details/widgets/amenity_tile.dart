import 'package:flutter/material.dart';

import '../../home/models/amenity.dart';
import '../../home/utils/amenity_icons.dart';

class AmenityTile extends StatelessWidget {
  const AmenityTile({super.key, required this.amenity, required this.isArabic});

  final Amenity amenity;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = isArabic ? amenity.nameAr : amenity.name;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AmenityIcons.resolve(amenity.icon), size: 18, color: theme.colorScheme.onSurface),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
