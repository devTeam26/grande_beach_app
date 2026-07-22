import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../booking/widgets/booking_info_row.dart';
import '../../booking/widgets/receipt_section.dart';
import '../models/price_preview_result.dart';

/// Chalet/add-ons/tax/total rows, followed by the backend's dynamic
/// breakdown list. Reuses [ReceiptSection]/[BookingInfoRow] from the
/// booking feature for a consistent receipt look.
class PriceBreakdownCard extends StatelessWidget {
  const PriceBreakdownCard({super.key, required this.preview});

  final PricePreviewResult preview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String money(double amount) =>
        '${l10n.kwdCurrency} ${amount.toStringAsFixed(2)}';

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReceiptSection(
            title: l10n.priceBreakdownTitle,
            children: [
              BookingInfoRow(
                label: l10n.baseAmountLabel,
                value: money(preview.baseAmount),
              ),
              if (preview.addOnsAmount > 0)
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
          // if (preview.breakdown.isNotEmpty) ...[
          //   const SizedBox(height: 24),
          //   for (final item in preview.breakdown)
          //     BookingInfoRow(
          //       label: item.description,
          //       value: money(item.amount),
          //     ),
          // ],
        ],
      ),
    );
  }
}
