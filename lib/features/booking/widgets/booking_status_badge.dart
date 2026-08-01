import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../models/booking_status.dart';

/// Colored pill showing a booking's current status.
class BookingStatusBadge extends StatelessWidget {
  const BookingStatusBadge({super.key, required this.status});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = status.color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label(l10n),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
