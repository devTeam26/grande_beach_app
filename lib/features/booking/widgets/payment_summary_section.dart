import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../models/booking.dart';
import 'booking_info_row.dart';
import 'receipt_section.dart';

/// Receipt-style checkout summary — base amount, tax, optional add-ons and
/// discount, then an emphasized total row.
class PaymentSummarySection extends StatelessWidget {
  const PaymentSummarySection({super.key, required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    String money(double amount) => '${l10n.kwdCurrency} ${amount.toStringAsFixed(2)}';

    return ReceiptSection(
      title: l10n.checkoutSummaryTitle,
      children: [
        BookingInfoRow(
          label: l10n.baseAmountLabel,
          value: money(booking.baseAmount),
        ),
        BookingInfoRow(
          label: l10n.taxAmountLabel,
          value: money(booking.taxAmount),
        ),
        if (booking.addOnsAmount > 0)
          BookingInfoRow(
            label: l10n.addOnAmountLabel,
            value: money(booking.addOnsAmount),
          ),
        if (booking.discountAmount > 0)
          BookingInfoRow(
            label: l10n.discountAmountLabel,
            value: '-${money(booking.discountAmount)}',
          ),
        const Divider(height: 20),
        BookingInfoRow(
          label: l10n.totalAmountLabel,
          value: money(booking.totalAmount),
          emphasize: true,
        ),
      ],
    );
  }
}
