import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grande_beach/core/config/app_icons.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/common_header.dart';
import '../../authentication/controllers/auth_providers.dart';
import '../../authentication/widgets/sign_in_required_state.dart';
import '../widgets/bookings_content.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final hasSession = ref.watch(sessionActiveProvider);

    return Scaffold(
      body: Column(
        children: [
          CommonHeader(
            title: Row(
              children: [
                const Icon(AppIcons.booking, size: 22, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  l10n.bookingsTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: hasSession
                ? const BookingsContent()
                : SignInRequiredState(
                    message: l10n.signInToViewBookings,
                    icon: Icons.calendar_month_outlined,
                    onLogin: () => context.push('/login'),
                  ),
          ),
        ],
      ),
    );
  }
}
