import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/extensions/failure_localization_extension.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/app_action_dialog.dart';
import '../controllers/profile_controller.dart';

/// Warns the user that deleting their account is permanent and, on confirm,
/// deletes it. Stays open (and undismissable) while the request runs; closes
/// on success — the user continues as a guest — or on failure, showing
/// the error in a snackbar.
class DeleteAccountDialog extends ConsumerWidget {
  const DeleteAccountDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const DeleteAccountDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isDeleting = ref.watch(profileControllerProvider).isLoading;

    ref.listen<AsyncValue<void>>(profileControllerProvider, (previous, next) {
      if (previous?.isLoading != true || next.isLoading) return;
      if (!context.mounted) return;

      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop();

      final error = next.error;
      final message = next.hasError
          ? (error is Failure
                ? error.localizedMessageWithErrors(context)
                : l10n.errorUnknown)
          : l10n.accountDeletedSuccess;
      messenger.showSnackBar(SnackBar(content: Text(message)));
    });

    return PopScope(
      canPop: !isDeleting,
      child: AppActionDialog(
        icon: Icon(
          Icons.warning_amber_rounded,
          color: colorScheme.error,
          size: 26,
        ),
        title: l10n.deleteAccountConfirmTitle,
        message: l10n.deleteAccountConfirmMessage,
        actionLabel: l10n.deleteAccountConfirm,
        isLoading: isDeleting,
        onAction: () =>
            ref.read(profileControllerProvider.notifier).deleteAccount(),
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }
}
