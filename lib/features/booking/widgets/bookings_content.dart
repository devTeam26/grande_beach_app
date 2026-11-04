import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/navigation/nav_controller.dart';
import '../controllers/bookings_providers.dart';
import '../controllers/verification_providers.dart';
import '../models/booking_status.dart';
import '../models/verification_status.dart';
import 'booking_request_under_review_banner.dart';
import 'booking_status_tabs.dart';
import 'bookings_list.dart';
import 'verification_under_review_banner.dart';

/// Index of the Bookings tab in [MainShell]'s [IndexedStack].
const _bookingsTabIndex = 2;

/// The authenticated user's bookings: review banners, status tabs and the
/// paginated list. Only built when a session is active, so guests never
/// trigger the authenticated bookings/verification requests.
class BookingsContent extends ConsumerWidget {
  const BookingsContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(bookingTabProvider);

    final hasPendingBooking =
        ref
            .watch(bookingsProvider)
            .valueOrNull
            ?.bookings
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

    return Column(
      children: [
        if (showVerificationBanner)
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: VerificationUnderReviewBanner(),
          ),
        // else if (showBookingReviewBanner)
        //   const Padding(
        //     padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        //     child: BookingRequestUnderReviewBanner(),
        //   ),
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
    );
  }
}
