import 'package:flutter/material.dart';

import '../../../core/config/app_icons.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

/// "Details" section: master rooms, single rooms, and max guests, each
/// shown as an icon over a label, evenly spaced across the full width.
class ChaletDetailsSection extends StatelessWidget {
  const ChaletDetailsSection({
    super.key,
    required this.masterBedrooms,
    required this.singleBedrooms,
    required this.bathrooms,
    required this.hasServantRoom,
    required this.maxGuests,
  });

  final int masterBedrooms;
  final int singleBedrooms;
  final int bathrooms;
  final bool hasServantRoom;
  final int maxGuests;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final items = [
      _DetailItem(
        icon: AppIcons.masterRoom,
        label: '$masterBedrooms ${l10n.masterRoomsLabel}',
      ),
      _DetailItem(
        icon: AppIcons.singleRoom,
        label: '$singleBedrooms ${l10n.singleRoomsLabel}',
      ),
      _DetailItem(
        icon: AppIcons.bathroom,
        label: '$bathrooms ${l10n.bathroomsLabel}',
      ),
      _DetailItem(
        icon: AppIcons.guest,
        label: '$maxGuests ${l10n.maxGuestsLabel}',
      ),
      if (hasServantRoom)
        _DetailItem(
          icon: AppIcons.servantRoom,
          label: l10n.servantRoomLabel,
        ),
    ];

    const rowSize = 3;
    final rows = <List<Widget>>[
      for (var i = 0; i < items.length; i += rowSize)
        items.sublist(i, i + rowSize > items.length ? items.length : i + rowSize),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.detailsTitle,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const SizedBox(height: 16),
          rows[i].length == rowSize
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: rows[i],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var j = 0; j < rows[i].length; j++) ...[
                      if (j > 0) const SizedBox(width: 40),
                      rows[i][j],
                    ],
                  ],
                ),
        ],
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            // color: AppColors.primaryGold.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, size: 24, color: AppColors.primaryGold),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
