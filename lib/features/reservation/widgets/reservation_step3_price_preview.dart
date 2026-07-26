import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/error_state.dart';
import '../controllers/reservation_providers.dart';
import '../models/reservation_draft.dart';
import 'price_breakdown_card.dart';
import 'price_breakdown_skeleton.dart';

/// Step 3: displays the backend price preview for the current draft. The
/// fetch itself is triggered by [ReservationWizardScreen] when this step
/// becomes current (not here), since it needs the draft's field values at
/// the moment of entry.
class ReservationStep3PricePreview extends ConsumerWidget {
  const ReservationStep3PricePreview({super.key, required this.draft});

  final ReservationDraft draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewAsync = ref.watch(pricePreviewControllerProvider(draft.chaletId));
    final l10n = AppLocalizations.of(context);

    return previewAsync.when(
      loading: () => const PriceBreakdownSkeleton(),
      error: (_, _) => Center(
        child: ErrorState(
          message: l10n.errorLoadingPricePreview,
          onRetry: () => ref
              .read(pricePreviewControllerProvider(draft.chaletId).notifier)
              .fetch(draft),
        ),
      ),
      data: (preview) {
        if (preview == null) return const PriceBreakdownSkeleton();
        return SingleChildScrollView(
          child: PriceBreakdownCard(
            preview: preview,
            checkIn: draft.checkIn!,
            checkOut: draft.checkOut!,
          ),
        );
      },
    );
  }
}
