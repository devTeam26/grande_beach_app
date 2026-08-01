import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grande_beach/features/profile/widgets/profile_avatar.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/providers/notifications_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../authentication/controllers/auth_providers.dart';
import '../../language/screens/language_selection_sheet.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_header.dart';
import '../widgets/setting_row.dart';
import '../widgets/settings_section.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  static const double _avatarHeight = 140;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(currentUserProvider);
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final notificationsEnabled = ref.watch(notificationsProvider);
    final locale = Localizations.localeOf(context);
    final currentLanguageLabel = locale.languageCode == 'ar'
        ? l10n.arabic
        : l10n.english;
    final loyaltyPoints = user?.loyaltyPoints ?? 0;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          const ProfileHeader(),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              children: [
                ProfileAvatarSection(user: user, avatarHeight: _avatarHeight),

                const SizedBox(height: 24),
                SettingsSection(
                  title: l10n.personalInformation,
                  children: [
                    SettingRow(
                      icon: const Icon(Icons.person_outline),
                      title: l10n.accountInformation,
                      onTap: () => context.push('/account-info'),
                    ),
                    // SettingRow(
                    //   icon: const Icon(Icons.stars_outlined),
                    //   title: l10n.loyaltyPoints,
                    //   trailingValue: l10n.loyaltyPointsValue(
                    //     loyaltyPoints.toString(),
                    //   ),
                    //   onTap: () {}, // TODO: navigate to loyalty
                    // ),
                    SettingRow(
                      icon: const Icon(Icons.favorite_border),
                      title: l10n.wishlist,
                      onTap: () => context.push('/wishlist'),
                    ),
                    // SettingRow(
                    //   icon: const Icon(Icons.credit_card_outlined),
                    //   title: l10n.paymentMethods,
                    //   onTap: () {}, // TODO: navigate to payment methods
                    // ),
                    SettingRow(
                      icon: const Icon(Icons.lock_outline),
                      title: l10n.changePassword,
                      onTap: () => context.push('/change-password'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SettingsSection(
                  title: l10n.generalSettings,
                  children: [
                    SettingRow(
                      icon: const Icon(Icons.language),
                      title: l10n.language,
                      trailingValue: currentLanguageLabel,
                      onTap: () => LanguageSelectionSheet.show(
                        context,
                        onConfirmed: () {},
                      ),
                    ),
                    // SettingRow.withSwitch(
                    //   icon: const Icon(Icons.notifications_outlined),
                    //   title: l10n.notifications,
                    //   switchValue: notificationsEnabled,
                    //   onSwitchChanged: (_) =>
                    //       ref.read(notificationsProvider.notifier).toggle(),
                    // ),
                    SettingRow.withSwitch(
                      icon: const Icon(Icons.dark_mode_outlined),
                      title: l10n.darkMode,
                      switchValue: isDark,
                      onSwitchChanged: (_) =>
                          ref.read(themeModeProvider.notifier).toggle(),
                    ),
                    // SettingRow(
                    //   icon: const Icon(Icons.privacy_tip_outlined),
                    //   title: l10n.privacyPolicy,
                    //   onTap: () => context.push('/privacy-policy'),
                    // ),
                  ],
                ),
                const SizedBox(height: 20),
                SettingsSection(
                  title: '',
                  children: [
                    SettingRow(
                      icon: const Icon(Icons.logout),
                      title: l10n.logout,
                      isDestructive: true,
                      onTap: () => _confirmLogout(context, ref, l10n),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(l10n.logoutConfirmTitle),
        content: Text(l10n.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.logoutConfirm,
              style: const TextStyle(
                color: AppColors.primaryGold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(profileControllerProvider.notifier).logout();
    }
  }
}
