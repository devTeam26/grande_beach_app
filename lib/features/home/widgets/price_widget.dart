import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    super.key,
    required this.price,
    this.priceFontSize = 15,
    this.nightFontSize = 12,
  });

  final double price;
  final double priceFontSize;
  final double nightFontSize;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final subtleColor =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${l10n.kwdCurrency} ${price.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: priceFontSize,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryGold,
              fontStyle: FontStyle.italic,
            ),
          ),
          TextSpan(
            text: l10n.perNight,
            style: TextStyle(
              fontSize: nightFontSize,
              fontWeight: FontWeight.w400,
              color: subtleColor,
            ),
          ),
        ],
      ),
    );
  }
}
