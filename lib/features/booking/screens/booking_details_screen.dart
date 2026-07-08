import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/error_state.dart';
import '../controllers/booking_details_providers.dart';
import '../widgets/booking_details_skeleton.dart';
import '../widgets/booking_header_card.dart';
import '../widgets/booking_info_section.dart';
import '../widgets/cancel_reservation_button.dart';
import '../widgets/customer_info_section.dart';
import '../widgets/payment_summary_section.dart';

/// Full booking receipt, reached from the Bookings screen via "View Ticket".
class BookingDetailsScreen extends ConsumerWidget {
  const BookingDetailsScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bookingAsync = ref.watch(bookingDetailsProvider(bookingId));
        final theme = Theme.of(context);


    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: Text(l10n.bookingDetailsTitle),forceMaterialTransparency: true,),
      bottomNavigationBar: bookingAsync.maybeWhen(
        data: (_) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: CancelReservationButton(bookingId: bookingId),
        ),
        orElse: () => null,
      ),
      body: bookingAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(16),
          child: BookingDetailsSkeleton(),
        ),
        error: (_, _) => Center(
          child: ErrorState(
            message: l10n.errorLoadingBookingDetails,
            onRetry: () => ref.invalidate(bookingDetailsProvider(bookingId)),
          ),
        ),
        data: (booking) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BookingHeaderCard(booking: booking),
              const SizedBox(height: 20),
              BookingInfoSection(booking: booking),
              const Divider(height: 40),
              CustomerInfoSection(booking: booking),
              const Divider(height: 40),
              PaymentSummarySection(booking: booking),
            ],
          ),
        ),
      ),
    );
  }
}
