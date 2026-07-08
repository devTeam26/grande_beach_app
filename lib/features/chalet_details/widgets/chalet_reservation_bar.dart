import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/widgets/price_widget.dart';

/// Fixed bottom bar: price on the left, a Reserve button on the right.
/// Rendered via [Scaffold.bottomNavigationBar] so it never scrolls.
class ChaletReservationBar extends StatelessWidget {
  const ChaletReservationBar({
    super.key,
    required this.price,
    required this.onReserve,
  });

  final double price;
  final VoidCallback onReserve;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: PriceWidget(price: price, priceFontSize: 20, nightFontSize: 13),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: onReserve,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGold,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                l10n.reserve,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
