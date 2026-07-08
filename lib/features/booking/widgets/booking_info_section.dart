import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../models/booking.dart';
import 'booking_info_row.dart';
import 'receipt_section.dart';

/// Receipt-style section listing booking number, dates, nights, and guests.
class BookingInfoSection extends StatelessWidget {
  const BookingInfoSection({super.key, required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final dateFormat = DateFormat.yMMMd(locale);

    return ReceiptSection(
      title: l10n.bookingInformationTitle,
      children: [
        BookingInfoRow(
          label: l10n.bookingNumberLabel,
          value: booking.bookingNumber,
        ),
        BookingInfoRow(
          label: l10n.checkInLabel,
          value: dateFormat.format(booking.checkInDate),
        ),
        BookingInfoRow(
          label: l10n.checkOutLabel,
          value: dateFormat.format(booking.checkOutDate),
        ),
        BookingInfoRow(
          label: l10n.nightsLabel,
          value: '${booking.nights}',
        ),
        BookingInfoRow(
          label: l10n.guestCountLabel,
          value: '${booking.guestCount}',
        ),
      ],
    );
  }
}
