import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/config/images.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/network_or_asset_image.dart';
import '../models/booking.dart';
import '../models/booking_status.dart';
import 'booking_status_badge.dart';

/// A single booking entry shown in the Bookings list. Tapping anywhere on
/// the card opens the booking's details; ongoing bookings additionally show
/// a "View Ticket" button (plus "Verify" while still pending), and completed
/// bookings a "Write a Review" button.
class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.booking,
    required this.onViewTicket,
    this.onWriteReview,
    this.onVerify,
  });

  final Booking booking;
  final VoidCallback onViewTicket;

  /// Shown as a "Write a Review" button for completed bookings.
  final VoidCallback? onWriteReview;

  /// Shown as a "Verify" button alongside "View Ticket" for pending bookings.
  final VoidCallback? onVerify;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isOngoing = BookingTab.ongoing.matches(booking.status);
    final isCompleted = BookingTab.completed.matches(booking.status);
    final isPending = booking.status == BookingStatus.pending;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onViewTicket,
        child: Container(
          decoration: BoxDecoration(
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
                        Text(
                          booking.chaletName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${l10n.from} ${_formatDate(context, booking.checkInDate)} - '
                          '${l10n.to} ${_formatDate(context, booking.checkOutDate)}',
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
                if (isPending && onVerify != null)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onVerify,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppColors.primaryGold),
                            shape: const StadiumBorder(),
                          ),
                          child: Text(
                            l10n.verifyButton,
                            style: const TextStyle(
                              color: AppColors.primaryGold,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          label: l10n.viewTicket,
                          onPressed: onViewTicket,
                        ),
                      ),
                    ],
                  )
                else
                  AppButton(label: l10n.viewTicket, onPressed: onViewTicket),
              ] else if (isCompleted && onWriteReview != null) ...[
                const SizedBox(height: 16),
                AppButton(label: l10n.writeReviewButton, onPressed: onWriteReview),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat.MMMd(locale).format(date);
  }
}
