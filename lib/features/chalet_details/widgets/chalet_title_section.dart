import 'package:flutter/material.dart';

import 'chalet_type_badge.dart';

class ChaletTitleSection extends StatelessWidget {
  const ChaletTitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.type,
    required this.typeName,
  });

  final String name;
  final String location;
  final String type;
  final String typeName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),
            ChaletTypeBadge(type: type, typeName: typeName),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                location,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
