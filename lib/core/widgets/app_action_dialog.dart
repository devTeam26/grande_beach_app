import 'package:flutter/material.dart';

import '../localization/generated/app_localizations.dart';
import 'app_dialog_pill_button.dart';

/// Shared confirmation dialog: title (with an optional leading icon) and a
/// close button on the top row, the message below, and a trailing row with a
/// Cancel pill followed by the main action pill. Used by the login-required,
/// logout and delete-account dialogs so they all look the same. Layout uses
/// directional alignment, so it mirrors correctly in Arabic (RTL).
class AppActionDialog extends StatelessWidget {
  const AppActionDialog({
    super.key,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    required this.onCancel,
    this.icon,
    this.isLoading = false,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  /// Used by both the Cancel button and the close (✕) button.
  final VoidCallback onCancel;

  /// Optional small icon shown before the title (e.g. a warning).
  final Widget? icon;

  /// Shows a spinner in the action button and disables every button.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 12, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 10)],
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.close,
                    onPressed: isLoading ? null : onCancel,
                    icon: const Icon(Icons.close),
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 12),
                child: Text(
                  message,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 12),
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      AppDialogPillButton(
                        label: l10n.cancel,
                        onPressed: isLoading ? null : onCancel,
                      ),
                      AppDialogPillButton(
                        label: actionLabel,
                        isPrimary: true,
                        isLoading: isLoading,
                        onPressed: onAction,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
