import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/app_button.dart';
import '../controllers/cancel_booking_providers.dart';

/// Bottom sheet collecting a cancellation reason, then calling
/// `/api/Bookings/{id}/cancel` via [CancelBookingController].
class CancelBookingSheet extends ConsumerStatefulWidget {
  const CancelBookingSheet({super.key, required this.bookingId});

  final String bookingId;

  static Future<void> show(BuildContext context, {required String bookingId}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => CancelBookingSheet(bookingId: bookingId),
    );
  }

  @override
  ConsumerState<CancelBookingSheet> createState() => _CancelBookingSheetState();
}

class _CancelBookingSheetState extends ConsumerState<CancelBookingSheet> {
  final _reasonController = TextEditingController();
  String? _validationError;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _onConfirm() async {
    final l10n = AppLocalizations.of(context);
    final reason = _reasonController.text.trim();

    if (reason.isEmpty) {
      setState(() => _validationError = l10n.cancelReasonRequired);
      return;
    }
    setState(() => _validationError = null);

    final succeeded = await ref
        .read(cancelBookingControllerProvider(widget.bookingId).notifier)
        .cancel(reason);

    if (succeeded && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cancelState = ref.watch(cancelBookingControllerProvider(widget.bookingId));
    final serverError =
        cancelState.hasError ? (cancelState.error as Failure).message : null;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              l10n.cancelReservationSheetTitle,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.cancelReservationReasonLabel,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: l10n.cancelReservationReasonHint,
                errorText: _validationError ?? serverError,
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              label: l10n.confirmCancellation,
              isLoading: cancelState.isLoading,
              onPressed: _onConfirm,
            ),
          ],
        ),
      ),
    );
  }
}
