import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Small colored pill showing the chalet's type (Standard/Superior/VIP).
/// Color varies by the raw backend [type] value; [typeName] is the
/// localized/display label shown inside the pill.
class ChaletTypeBadge extends StatelessWidget {
  const ChaletTypeBadge({
    super.key,
    required this.type,
    required this.typeName,
  });

  final String type;
  final String typeName;

  Color get _color {
    switch (type) {
      case 'VIP':
        return const Color(0xFF7B4FE0);
      case 'Superior':
        return AppColors.primaryGold;
      case 'Standard':
      default:
        return AppColors.primaryGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        typeName,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
