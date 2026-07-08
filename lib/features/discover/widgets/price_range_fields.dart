import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';

/// Side-by-side min/max price inputs with inline range validation.
class PriceRangeFields extends StatelessWidget {
  const PriceRangeFields({
    super.key,
    required this.minController,
    required this.maxController,
    required this.onMinChanged,
    required this.onMaxChanged,
    this.errorText,
  });

  final TextEditingController minController;
  final TextEditingController maxController;
  final ValueChanged<String> onMinChanged;
  final ValueChanged<String> onMaxChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fillColor = AppColors.inputFill(Theme.of(context).brightness);
    final formatters = [
      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: minController,
                label: l10n.minPriceLabel,
                hint: '0',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: formatters,
                fillColor: fillColor,
                borderColor: Colors.transparent,
                focusedBorderColor: Colors.transparent,
                onChanged: onMinChanged,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                controller: maxController,
                label: l10n.maxPriceLabel,
                hint: '0',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: formatters,
                fillColor: fillColor,
                borderColor: Colors.transparent,
                focusedBorderColor: Colors.transparent,
                onChanged: onMaxChanged,
              ),
            ),
          ],
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.error),
          ),
        ],
      ],
    );
  }
}
