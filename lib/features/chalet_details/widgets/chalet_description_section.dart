import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

/// "About this chalet" section with a smooth expand/collapse for long text.
class ChaletDescriptionSection extends StatefulWidget {
  const ChaletDescriptionSection({super.key, required this.description});

  final String description;

  static const int _collapsedMaxLines = 3;

  @override
  State<ChaletDescriptionSection> createState() => _ChaletDescriptionSectionState();
}

class _ChaletDescriptionSectionState extends State<ChaletDescriptionSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.aboutThisChalet,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topLeft,
          child: Text(
            widget.description,
            maxLines: _expanded
                ? null
                : ChaletDescriptionSection._collapsedMaxLines,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              _expanded ? l10n.showLess : l10n.showMore,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryGold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
