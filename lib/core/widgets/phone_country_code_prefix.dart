import 'package:flutter/material.dart';

/// Fixed country-code label shown at the start of a phone number field,
/// separated from the input by a thin divider. Always laid out LTR so the
/// `+` stays in front of the digits in Arabic.
class PhoneCountryCodePrefix extends StatelessWidget {
  const PhoneCountryCodePrefix({super.key, required this.countryCode});

  final String countryCode;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16, end: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            countryCode,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 24,
            child: VerticalDivider(width: 1, thickness: 1, color: cs.outline),
          ),
        ],
      ),
    );
  }
}
