import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../localization/generated/app_localizations.dart';
import '../providers/core_providers.dart';

/// Circular WhatsApp button shown in [CommonHeader], opening a support chat
/// with the resort's WhatsApp number pre-filled with a generic greeting.
class WhatsAppHeaderButton extends ConsumerWidget {
  const WhatsAppHeaderButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () => ref.read(whatsAppServiceProvider).openSupportChat(l10n),
      child: const Icon(
        FontAwesomeIcons.whatsapp,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}
