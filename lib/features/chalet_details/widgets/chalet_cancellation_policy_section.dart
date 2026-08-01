import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/theme/app_colors.dart';

/// Cancellation policy section — points users to WhatsApp support instead of
/// listing rigid rules, since policy details are handled by the support team.
class ChaletCancellationPolicySection extends ConsumerWidget {
  const ChaletCancellationPolicySection({super.key, required this.chaletName});

  final String chaletName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.cancellationPolicyTitle,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.cancellationPolicyContactMessage,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => ref
              .read(whatsAppServiceProvider)
              .openChaletCancelationPolicyInquiry(l10n, chaletName: chaletName),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                FontAwesomeIcons.whatsapp,
                size: 16,
                color: AppColors.whatsappGreen,
              ),
              const SizedBox(width: 6),
              Text(
                l10n.contactUsOnWhatsapp,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.whatsappGreen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
