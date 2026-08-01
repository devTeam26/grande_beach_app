import 'package:flutter/material.dart';

import '../config/app_icons.dart';
import '../localization/generated/app_localizations.dart';
import '../theme/app_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    const selectedColor = AppColors.primaryGold;
    final unselectedColor = theme.colorScheme.onSurfaceVariant;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: selectedColor,
      unselectedItemColor: unselectedColor,
      backgroundColor: theme.colorScheme.surface,
      elevation: 8,
      selectedLabelStyle: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(fontSize: 11),
      items: [
        BottomNavigationBarItem(
          icon: Icon(AppIcons.home, size: 24, color: unselectedColor),
          activeIcon: Icon(AppIcons.home, size: 24, color: selectedColor),
          label: l10n.navHome,
        ),
        BottomNavigationBarItem(
          icon: Icon(AppIcons.discover, size: 24, color: unselectedColor),
          activeIcon: Icon(AppIcons.discover, size: 24, color: selectedColor),
          label: l10n.navDiscover,
        ),
        BottomNavigationBarItem(
          icon: Icon(AppIcons.booking, size: 24, color: unselectedColor),
          activeIcon: Icon(AppIcons.booking, size: 24, color: selectedColor),
          label: l10n.navBookings,
        ),
        BottomNavigationBarItem(
          icon: Icon(AppIcons.profile, size: 24, color: unselectedColor),
          activeIcon: Icon(AppIcons.profile, size: 24, color: selectedColor),
          label: l10n.navProfile,
        ),
      ],
    );
  }
}
