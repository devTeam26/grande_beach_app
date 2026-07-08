import 'package:flutter/material.dart';

import '../models/booking.dart';
import 'booking_status_badge.dart';

/// Summary card at the top of the Booking Details screen: chalet name and
/// status badge.
class BookingHeaderCard extends StatelessWidget {
  const BookingHeaderCard({super.key, required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric( vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surfaceContainerHigh : theme.colorScheme.surface,
        // borderRadius: BorderRadius.circular(16),
        // boxShadow: isDark
        //     ? null
        //     : [
        //         BoxShadow(
        //           color: Colors.black.withValues(alpha: 0.06),
        //           blurRadius: 12,
        //           offset: const Offset(0, 4),
        //         ),
        //       ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              booking.chaletName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          BookingStatusBadge(status: booking.status),
        ],
      ),
    );
  }
}
