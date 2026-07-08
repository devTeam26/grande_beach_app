import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../authentication/controllers/auth_providers.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(currentUserProvider);
    final firstName = user?.firstName ?? '';

    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(l10n.greeting(firstName)),
      actions: [
        IconButton(
          tooltip: l10n.notifications,
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {}, // TODO: navigate to notifications
        ),
      ],
    );
  }
}
