import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_icons.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/common_header.dart';

/// Gold header for the Profile screen — shows profile icon + title.
/// The avatar section is rendered separately in the screen body.
class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key, this.onNotificationTap});

  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return CommonHeader(
      onNotificationTap: onNotificationTap,
      title: Row(
        children: [
          const Icon(AppIcons.profile, size: 20, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            l10n.profileTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
