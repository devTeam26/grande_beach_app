import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grande_beach/core/config/app_icons.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/navigation/nav_controller.dart';
import '../../../core/widgets/common_header.dart';
import '../controllers/bookings_providers.dart';
import '../controllers/verification_providers.dart';
import '../models/booking_status.dart';
import '../models/verification_status.dart';
import '../widgets/booking_request_under_review_banner.dart';
import '../widgets/booking_status_tabs.dart';
import '../widgets/bookings_list.dart';
import '../widgets/verification_under_review_banner.dart';

/// Index of the Bookings tab in [MainShell]'s [IndexedStack].
const _bookingsTabIndex = 2;

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selectedTab = ref.watch(bookingTabProvider);

    final hasPendingBooking = ref.watch(bookingsProvider).valueOrNull?.bookings
            .any((b) => b.status == BookingStatus.pending) ??
        false;
    final verificationStatus =
        ref.watch(verificationStatusProvider).valueOrNull ??
            VerificationStatus.unknown;
    // Mutually exclusive: unverified/pending-review guests see the
    // verification banner; already-verified guests see the booking-review
    // banner instead. Never both at once.
    final showVerificationBanner =
        hasPendingBooking && verificationStatus == VerificationStatus.pending;
    final showBookingReviewBanner =
        hasPendingBooking && verificationStatus == VerificationStatus.approved;

    // MainShell keeps every tab alive in an IndexedStack, so this screen is
    // built once and never again on its own — watch the active tab and
    // refetch whenever the user switches back into Bookings, so newly
    // created bookings show up without a manual pull-to-refresh.
    ref.listen(navControllerProvider, (previous, next) {
      if (next == _bookingsTabIndex && previous != _bookingsTabIndex) {
        // Also refreshes the cached verification status alongside the
        // bookings data — see BookingsNotifier.refresh().
        ref.read(bookingsProvider.notifier).refresh();
      }
    });

    return Scaffold(
      body: Column(
        children: [
          CommonHeader(
            title: Row(
              children: [
                const Icon(AppIcons.booking, size: 22, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  l10n.bookingsTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (showVerificationBanner)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: VerificationUnderReviewBanner(),
            )
          // else if (showBookingReviewBanner)
          //   const Padding(
          //     padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          //     child: BookingRequestUnderReviewBanner(),
          //   ),
          ,
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 4),
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
