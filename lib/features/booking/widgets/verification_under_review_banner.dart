import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/status_info_banner.dart';

/// Shown while the guest's verification documents are awaiting admin review
/// (e.g. at the bottom of the Booking Details screen).
class VerificationUnderReviewBanner extends StatelessWidget {
  const VerificationUnderReviewBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StatusInfoBanner(
      message: l10n.verificationUnderReviewMessage,
      icon: LucideIcons.clock,
      color: AppColors.statusPending,
    );
  }
}
