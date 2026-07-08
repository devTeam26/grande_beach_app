import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/navigation/nav_controller.dart';
import '../../../core/widgets/error_state.dart';
import '../controllers/bookings_providers.dart';
import '../models/booking_status.dart';
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
      error: (_, _) => ErrorState(
        message: l10n.errorLoadingBookings,
        onRetry: () => ref.read(bookingsProvider.notifier).retry(),
      ),
      data: (state) {
        final filtered =
            state.bookings.where((b) => widget.tab.matches(b.status)).toList();

        if (filtered.isEmpty) {
          return Center(
            child: BookingsEmptyState(
              onExploreChalets: widget.tab == BookingTab.ongoing
                  ? () => ref.read(navControllerProvider.notifier).setTab(1)
                  : null,
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
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
              child: BookingCard(
                booking: booking,
                onViewTicket: () =>
                    context.push('/booking-details/${booking.id}'),
              ),
            );
          },
        );
      },
    );
  }
}
