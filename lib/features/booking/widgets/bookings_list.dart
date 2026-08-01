import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/navigation/nav_controller.dart';
import '../../../core/widgets/error_state.dart';
import '../../reviews/controllers/reviews_providers.dart';
import '../../reviews/widgets/submit_review_sheet.dart';
import '../controllers/bookings_providers.dart';
import '../controllers/verification_providers.dart';
import '../models/booking_status.dart';
import '../models/verification_status.dart';
import 'booking_card.dart';
import 'booking_skeletons.dart';
import 'bookings_empty_state.dart';

/// Scrollable, paginated list of the current tab's bookings.
class BookingsList extends ConsumerStatefulWidget {
  const BookingsList({super.key, required this.tab});

  final BookingTab tab;

  @override
  ConsumerState<BookingsList> createState() => _BookingsListState();
}

class _BookingsListState extends ConsumerState<BookingsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(bookingsProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bookingsAsync = ref.watch(bookingsProvider);

    return bookingsAsync.when(
      loading: () => const SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: BookingsListSkeleton(),
      ),
      error: (_, _) => Center(
        child: ErrorState(
          message: l10n.errorLoadingBookings,
          onRetry: () => ref.read(bookingsProvider.notifier).retry(),
        ),
      ),
      data: (state) {
        final filtered =
            state.bookings.where((b) => widget.tab.matches(b.status)).toList();

        return RefreshIndicator(
          onRefresh: () => ref.read(bookingsProvider.notifier).refresh(),
          child: filtered.isEmpty
              ? LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Center(
                        child: BookingsEmptyState(
                          onExploreChalets: widget.tab == BookingTab.ongoing
                              ? () => ref
                                  .read(navControllerProvider.notifier)
                                  .setTab(1)
                              : null,
                        ),
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  itemCount: filtered.length + 1,
                  itemBuilder: (context, index) {
                    if (index == filtered.length) {
                      return state.isLoadingMore
                          ? const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: BookingCardSkeleton(),
                            )
                          : const SizedBox.shrink();
                    }

                    final booking = filtered[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Consumer(
                        builder: (context, ref, _) {
                          // Defaults to hidden while the check is in
                          // flight, to avoid flashing the button and then
                          // hiding it once the server confirms a review
                          // already exists.
                          final alreadyReviewed = ref
                              .watch(isBookingReviewedProvider((
                                bookingId: booking.id,
                                chaletId: booking.chaletId,
                              )))
                              .maybeWhen(data: (v) => v, orElse: () => true);
                          final verificationStatus = ref
                                  .watch(verificationStatusProvider)
                                  .valueOrNull ??
                              VerificationStatus.unknown;
                          // Approved and pending users never see "Verify" —
                          // there's nothing left for them to submit.
                          final canVerify = verificationStatus ==
                                  VerificationStatus.unknown ||
                              verificationStatus == VerificationStatus.rejected;

                          return BookingCard(
                            booking: booking,
                            onViewTicket: () => context
                                .push('/booking-details/${booking.id}'),
                            onWriteReview: widget.tab == BookingTab.completed &&
                                    !alreadyReviewed
                                ? () => SubmitReviewSheet.show(
                                      context,
                                      bookingId: booking.id,
                                    )
                                : null,
                            onVerify: widget.tab == BookingTab.ongoing && canVerify
                                ? () => context
                                    .push('/booking-verification/${booking.id}')
                                : null,
                          );
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
