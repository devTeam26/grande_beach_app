import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/empty_state.dart';

/// Empty state shown when the user has no bookings, with an optional
/// "Explore Chalets" call to action.
class BookingsEmptyState extends StatelessWidget {
  const BookingsEmptyState({super.key, this.onExploreChalets});

  final VoidCallback? onExploreChalets;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
   
      children: [
        EmptyState(
          title: l10n.noBookingsYet,
          subtitle: l10n.noBookingsYetSubtitle,
          icon: Icons.calendar_month_outlined,
        ),
        if (onExploreChalets != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AppButton(
              label: l10n.exploreChalets,
              onPressed: onExploreChalets,
            ),
          ),
      ],
    );
  }
}
