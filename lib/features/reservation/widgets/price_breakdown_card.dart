import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../core/localization/generated/app_localizations.dart';
import '../../booking/widgets/booking_info_row.dart';
import '../../booking/widgets/receipt_section.dart';
import '../models/price_preview_result.dart';
import 'addons_breakdown_section.dart';

/// Stay dates, followed by chalet/add-ons/tax/total rows and the backend's
/// dynamic breakdown list. Reuses [ReceiptSection]/[BookingInfoRow] from the
/// booking feature for a consistent receipt look.
class PriceBreakdownCard extends StatelessWidget {
  const PriceBreakdownCard({
    super.key,
    required this.preview,
    required this.checkIn,
    required this.checkOut,
  });

  final PricePreviewResult preview;
  final DateTime checkIn;
  final DateTime checkOut;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final dateFormat = DateFormat.yMMMd(locale);
    String money(double amount) =>
        '${l10n.kwdCurrency} ${amount.toStringAsFixed(2)}';

    final breakdown = preview.breakdown;
    // The backend's first breakdown entry is the base-rate line (e.g. "Base
    // rate (3 nights)"); everything after it is an add-on line item.
    final baseLabel =
        breakdown.isNotEmpty ? breakdown.first.description : l10n.baseAmountLabel;
    final addOnItems =
        breakdown.length > 1 ? breakdown.sublist(1) : const <PriceBreakdownItem>[];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BookingInfoRow(label: l10n.from, value: dateFormat.format(checkIn)),
          BookingInfoRow(label: l10n.to, value: dateFormat.format(checkOut)),
          const Divider(height: 24),
          ReceiptSection(
            title: l10n.priceBreakdownTitle,
            children: [
              BookingInfoRow(
                label: baseLabel,
                value: money(preview.baseAmount),
              ),
              if (addOnItems.isNotEmpty)
                AddOnsBreakdownSection(
                  title: l10n.addOnAmountLabel,
                  totalValue: money(preview.addOnsAmount),
                  children: [
                    for (final item in addOnItems)
                      BookingInfoRow(
                        label: item.description,
                        value: money(item.amount),
                      ),
                    // const Divider(height: 16),
                    // BookingInfoRow(
                    //   label: l10n.addOnsSubtotalLabel,
                    //   value: money(preview.addOnsAmount),
                    //   emphasize: true,
                    // ),
                  ],
                )
              else if (preview.addOnsAmount > 0)
                BookingInfoRow(
                  label: l10n.addOnAmountLabel,
                  value: money(preview.addOnsAmount),
                ),
              BookingInfoRow(
                label: l10n.taxAmountLabel,
                value: money(preview.taxAmount),
              ),
              const Divider(height: 20),
              BookingInfoRow(
                label: l10n.totalAmountLabel,
                value: money(preview.totalAmount),
                emphasize: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
