import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../models/booking.dart';
import 'booking_info_row.dart';
import 'receipt_section.dart';

/// Section listing the guest's full name, email, and phone number.
class CustomerInfoSection extends StatelessWidget {
  const CustomerInfoSection({super.key, required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fullName = '${booking.guestFirstName} ${booking.guestLastName}'.trim();

    return ReceiptSection(
      title: l10n.customerInformationTitle,
      children: [
        BookingInfoRow(label: l10n.customerNameLabel, value: fullName),
        BookingInfoRow(label: l10n.customerEmailLabel, value: booking.guestEmail),
        BookingInfoRow(label: l10n.customerPhoneLabel, value: booking.guestPhone),
      ],
    );
  }
}
