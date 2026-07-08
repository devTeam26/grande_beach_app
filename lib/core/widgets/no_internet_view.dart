import 'package:flutter/material.dart';

import '../localization/generated/app_localizations.dart';
import '../theme/app_colors.dart';

/// Full-screen "no internet" placeholder shown globally whenever the app
/// loses connectivity. Visual language mirrors [ErrorState]/[EmptyState].
class NoInternetView extends StatefulWidget {
  const NoInternetView({super.key, required this.onRetry});

  /// Runs a fresh connectivity check. If it comes back online, this view
  /// is removed by the caller (e.g. [ConnectivityListener]); if not, the
  /// retry button simply becomes tappable again.
  final Future<void> Function() onRetry;

  @override
  State<NoInternetView> createState() => _NoInternetViewState();
}

class _NoInternetViewState extends State<NoInternetView> {
  bool _isChecking = false;

  Future<void> _handleRetry() async {
    if (_isChecking) return;
    setState(() => _isChecking = true);
    try {
      await widget.onRetry();
    } finally {
      if (mounted) setState(() => _isChecking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final subtleColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off_rounded, size: 72, color: subtleColor),
                const SizedBox(height: 20),
                Text(
                  l10n.noInternetTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.noInternetMessage,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: subtleColor,
                   decoration: TextDecoration.none
                  ),
                  
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isChecking ? null : _handleRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGold,
                    foregroundColor: Colors.white,
                  ),
                  child: _isChecking
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(l10n.retry),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
