import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/app_action_dialog.dart';

/// Tells a guest that an action needs an account, offering Login or Cancel.
/// Resolves to `true` only when the user chose Login; the caller decides how
/// to open the login flow so it can resume afterwards.
class LoginRequiredDialog extends StatelessWidget {
  const LoginRequiredDialog({super.key, required this.message});

  final String message;

  static Future<bool> show(BuildContext context, {required String message}) {
    return showDialog<bool>(
      context: context,
      builder: (_) => LoginRequiredDialog(message: message),
    ).then((value) => value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppActionDialog(
      title: l10n.loginRequiredTitle,
      message: message,
      actionLabel: l10n.login,
      onAction: () => Navigator.of(context).pop(true),
      onCancel: () => Navigator.of(context).pop(false),
    );
  }
}
