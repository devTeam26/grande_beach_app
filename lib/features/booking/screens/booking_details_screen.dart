import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/whatsapp_fab.dart';
import '../controllers/booking_details_providers.dart';
import '../controllers/verification_providers.dart';
import '../models/booking_status.dart';
import '../models/verification_status.dart';
import '../widgets/booking_details_skeleton.dart';
import '../widgets/booking_header_card.dart';
import '../widgets/booking_info_section.dart';
import '../widgets/booking_request_under_review_banner.dart';
import '../widgets/cancel_reservation_button.dart';
import '../widgets/cancellation_reason_section.dart';
import '../widgets/customer_info_section.dart';
import '../widgets/payment_summary_section.dart';
import '../widgets/verification_under_review_banner.dart';

/// Full booking receipt, reached from the Bookings screen via "View Ticket".
class BookingDetailsScreen extends ConsumerWidget {
  const BookingDetailsScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bookingAsync = ref.watch(bookingDetailsProvider(bookingId));
    final theme = Theme.of(context);
    final verificationStatus =
        ref.watch(verificationStatusProvider).valueOrNull ??
        VerificationStatus.unknown;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.bookingDetailsTitle),
        forceMaterialTransparency: true,
      ),
      floatingActionButton: bookingAsync.maybeWhen(
        data: (booking) => WhatsAppFab(
          onPressed: () => ref
              .read(whatsAppServiceProvider)
              .openBookingSupport(l10n, bookingNumber: booking.bookingNumber),
        ),
        orElse: () => null,
      ),
      bottomNavigationBar: bookingAsync.maybeWhen(
        data: (booking) => booking.status.isCancellable
            ? Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: CancelReservationButton(bookingId: bookingId),
              )
            : null,
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
        data: (booking) {
          final hasCancellationReason =
              (booking.status == BookingStatus.cancelled ||
                  booking.status == BookingStatus.rejected) &&
              (booking.cancellationReason?.isNotEmpty ?? false);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (booking.status == BookingStatus.pending &&
                    verificationStatus == VerificationStatus.pending) ...[
                  const VerificationUnderReviewBanner(),
                ] else if (booking.status == BookingStatus.pending &&
                    verificationStatus == VerificationStatus.approved) ...[
                  const BookingRequestUnderReviewBanner(),
                ],
                BookingHeaderCard(booking: booking),
                const SizedBox(height: 20),
                BookingInfoSection(booking: booking),
                const Divider(height: 40),
                CustomerInfoSection(booking: booking),
                const Divider(height: 40),
                PaymentSummarySection(booking: booking),
                if (hasCancellationReason) ...[
                  const Divider(height: 40),
                  CancellationReasonSection(
                    reason: booking.cancellationReason!,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
