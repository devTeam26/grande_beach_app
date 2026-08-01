import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/navigation/nav_controller.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../booking/screens/bookings_screen.dart';
import '../../discover/screens/discover_screen.dart';
import '../../home/screens/home_screen.dart';
import '../../profile/screens/profile_screen.dart';

/// Root scaffold for all authenticated tabs.
/// [IndexedStack] keeps every tab alive so state is preserved on switching.
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    DiscoverScreen(),
    BookingsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final currentIndex = ref.watch(navControllerProvider);

        return PopScope(
          // Home tab: allow the system back → exits the app.
          // Any other tab: intercept and go to Home first.
          canPop: currentIndex == 0,
          onPopInvokedWithResult: (bool didPop, _) {
            if (didPop) return;
            if (currentIndex != 0) {
              ref.read(navControllerProvider.notifier).goHome();
            } else {
              SystemNavigator.pop();
            }
          },
          child: Scaffold(
            body: IndexedStack(
              index: currentIndex,
              children: _screens,
            ),
            bottomNavigationBar: AppBottomNavBar(
              currentIndex: currentIndex,
              onTap: ref.read(navControllerProvider.notifier).setTab,
            ),
          ),
        );
      },
    );
  }
}
