import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/common_header.dart';
import '../controllers/bookings_providers.dart';
import '../widgets/booking_status_tabs.dart';
import '../widgets/bookings_list.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selectedTab = ref.watch(bookingTabProvider);

    return Scaffold(
      body: Column(
        children: [
          CommonHeader(
            title: Text(
              l10n.bookingsTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            onNotificationTap: () {},
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: BookingStatusTabs(
              selected: selectedTab,
              onChanged: (tab) =>
                  ref.read(bookingTabProvider.notifier).select(tab),
            ),
          ),
          Expanded(child: BookingsList(tab: selectedTab)),
        ],
      ),
    );
  }
}
