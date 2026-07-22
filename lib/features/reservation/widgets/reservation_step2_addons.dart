import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../controllers/reservation_providers.dart';
import '../models/reservation_draft.dart';
import 'add_on_card.dart';
import 'add_ons_list_skeleton.dart';

/// Step 2: optional, multi-select add-ons list.
class ReservationStep2AddOns extends ConsumerWidget {
  const ReservationStep2AddOns({super.key, required this.draft});

  final ReservationDraft draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addOnsAsync = ref.watch(addOnsProvider);
    final l10n = AppLocalizations.of(context);
    final isArabic = ref.watch(localeProvider).languageCode == 'ar';
    final controller =
        ref.read(reservationWizardControllerProvider(draft.chaletId).notifier);

    return addOnsAsync.when(
      loading: () => const AddOnsListSkeleton(),
      error: (_, _) => Center(
        child: ErrorState(
          message: l10n.errorLoadingAddOns,
          onRetry: () => ref.invalidate(addOnsProvider),
        ),
      ),
      data: (addOns) {
        if (addOns.isEmpty) {
          return Center(
            child: EmptyState(
              title: l10n.noAddOnsTitle,
              subtitle: l10n.noAddOnsSubtitle,
              icon: Icons.add_circle_outline_rounded,
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.addOnsListSubtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(height: 16),
              for (final addOn in addOns)
                AddOnCard(
                  addOn: addOn,
                  quantity: draft.selectedAddOns
                      .where((e) => e.addOn.id == addOn.id)
                      .fold(0, (_, e) => e.quantity),
                  maxQuantity: draft.guestCount ?? 1,
                  isArabic: isArabic,
                  onIncrement: () => controller.incrementAddOn(addOn),
                  onDecrement: () => controller.decrementAddOn(addOn),
                ),
            ],
          ),
        );
      },
    );
  }
}
