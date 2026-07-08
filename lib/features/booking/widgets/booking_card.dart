import 'package:flutter/material.dart';

import '../../../core/config/images.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/network_or_asset_image.dart';
import '../models/booking.dart';
import '../models/booking_status.dart';
import 'booking_status_badge.dart';

/// A single booking entry shown in the Bookings list.
class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.booking,
    required this.onViewTicket,
  });

  final Booking booking;
  final VoidCallback onViewTicket;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isOngoing = BookingTab.ongoing.matches(booking.status);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: NetworkOrAssetImage(
                  url: booking.chaletImageUrl ?? AppImages.chaletPlaceholder,
                  width: 84,
                  height: 84,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            booking.chaletName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                     
                      ],
                    ),
                    // const SizedBox(height: 6),
                    // if (booking.chaletLocation != null)
                    //   Text(
                    //     booking.chaletLocation!,
                    //     maxLines: 1,
                    //     overflow: TextOverflow.ellipsis,
                    //     style: theme.textTheme.bodySmall?.copyWith(
                    //       color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    //     ),
                    //   ),
                    const SizedBox(height: 6),
                    Text(
                      '${l10n.from} ${_formatDate(booking.checkInDate)} - ${l10n.to} ${_formatDate(booking.checkOutDate)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                       const SizedBox(height: 6),
                       BookingStatusBadge(status: booking.status),
                  ],
                ),
              ),
            ],
          ),
          if (isOngoing) ...[
            const SizedBox(height: 16),
            AppButton(label: l10n.viewTicket, onPressed: onViewTicket),
          ],
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}
