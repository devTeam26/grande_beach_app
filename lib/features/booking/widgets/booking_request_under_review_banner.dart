import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/status_info_banner.dart';

/// Shown on the Bookings screen for verified guests who have a booking
/// still awaiting admin confirmation.
class BookingRequestUnderReviewBanner extends StatelessWidget {
  const BookingRequestUnderReviewBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StatusInfoBanner(
      message: l10n.bookingRequestUnderReviewMessage,
      icon: LucideIcons.clock,
      color: AppColors.statusPending,
    );
  }
}
