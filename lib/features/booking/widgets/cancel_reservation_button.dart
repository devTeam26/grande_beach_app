import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/cancel_booking_providers.dart';
import 'cancel_booking_sheet.dart';

/// Full-width, outlined, red pill button that opens [CancelBookingSheet].
/// Once a cancellation request has been submitted, this is replaced by a
/// "pending cancellation" message instead.
class CancelReservationButton extends ConsumerWidget {
  const CancelReservationButton({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isPendingCancellation =
        ref.watch(cancelBookingControllerProvider(bookingId)).valueOrNull == true;

    if (isPendingCancellation) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.statusPending.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.hourglass_top_rounded,
                color: AppColors.statusPending, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                l10n.bookingPendingCancellationMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.statusPending,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final errorColor = Theme.of(context).colorScheme.error;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: errorColor,
          side: BorderSide(color: errorColor, width: 1.5),
          shape: const StadiumBorder(),
        ),
        onPressed: () => CancelBookingSheet.show(context, bookingId: bookingId),
        child: Text(
          l10n.cancelReservation,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
