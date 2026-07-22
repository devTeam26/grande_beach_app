import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../discover/widgets/date_range_picker.dart';
import '../controllers/reservation_providers.dart';
import '../models/reservation_draft.dart';
import 'guest_count_stepper.dart';

/// Step 1: check-in/check-out dates, guest count, and an optional special
/// request note.
class ReservationStep1Dates extends ConsumerStatefulWidget {
  const ReservationStep1Dates({
    super.key,
    required this.draft,
    required this.maxGuests,
  });

  final ReservationDraft draft;
  final int maxGuests;

  @override
  ConsumerState<ReservationStep1Dates> createState() =>
      _ReservationStep1DatesState();
}

class _ReservationStep1DatesState extends ConsumerState<ReservationStep1Dates> {
  late final _specialRequestController =
      TextEditingController(text: widget.draft.specialRequest);

  @override
  void dispose() {
    _specialRequestController.dispose();
    super.dispose();
  }

  void _showBlockedMessage(BuildContext context, AppLocalizations l10n) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.selectedRangeUnavailable),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chaletId = widget.draft.chaletId;
    final controller = ref.read(
      reservationWizardControllerProvider(chaletId).notifier,
    );

    final availabilityAsync = ref.watch(availabilityControllerProvider(chaletId));
    final availabilityController =
        ref.read(availabilityControllerProvider(chaletId).notifier);

    final availabilityError = availabilityAsync.hasError
        ? (availabilityAsync.error is Failure
            ? (availabilityAsync.error as Failure).message
            : l10n.errorLoadingAvailability)
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DateRangePicker(
            checkIn: widget.draft.checkIn,
            checkOut: widget.draft.checkOut,
            onCheckInChanged: controller.updateCheckIn,
            onCheckOutChanged: controller.updateCheckOut,
            availability: availabilityAsync.valueOrNull,
            // AsyncData(null) is the "not requested yet" state before the
            // picker reports its initial month; show the skeleton for it too.
            isLoadingAvailability: availabilityAsync.isLoading ||
                (!availabilityAsync.hasError &&
                    availabilityAsync.valueOrNull == null),
            availabilityError: availabilityError,
            onRetry: availabilityController.retry,
            onMonthChanged: availabilityController.showMonth,
            onBlockedSelection: () => _showBlockedMessage(context, l10n),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.weekendPricingNote,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GuestCountStepper(
            value: widget.draft.guestCount,
            maxGuests: widget.maxGuests,
            onChanged: controller.updateGuestCount,
          ),
          const SizedBox(height: 24),
          AppTextField(
            controller: _specialRequestController,
            label: l10n.specialRequestLabel,
            hint: l10n.specialRequestHint,
            maxLines: 3,
            textInputAction: TextInputAction.done,
            onChanged: controller.updateSpecialRequest,
          ),
        ],
      ),
    );
  }
}
