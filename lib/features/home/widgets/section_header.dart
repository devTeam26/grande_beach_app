import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
  });

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        // if (onSeeAll != null)
        //   GestureDetector(
        //     onTap: onSeeAll,
        //     child: Padding(
        //       padding: const EdgeInsets.only(left: 8),
        //       child: Text(
        //         l10n.seeAll,
        //         style: const TextStyle(
        //           fontSize: 14,
        //           fontWeight: FontWeight.w500,
        //           color: AppColors.primaryGold,
        //         ),
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}
