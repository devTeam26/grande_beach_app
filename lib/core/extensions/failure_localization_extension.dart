import 'package:flutter/widgets.dart';

import '../errors/failure.dart';
import '../localization/generated/app_localizations.dart';

/// Maps a [Failure] to a user-friendly, localized message.
extension FailureLocalization on Failure {
  String localizedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      NoInternetFailure() => l10n.errorNoInternet,
      NetworkFailure() => l10n.errorNetwork,
      ServerFailure() => l10n.errorServer,
      UnauthorizedFailure() => l10n.errorInvalidCredentials,
      ValidationFailure(message: final m) => m,
      UnknownFailure() => l10n.errorUnknown,
      GoogleSignInFailure(reason: final r) => switch (r) {
        GoogleSignInFailureReason.cancelled => l10n.googleSignInCancelled,
        GoogleSignInFailureReason.failed => l10n.googleSignInFailed,
        GoogleSignInFailureReason.unavailable => l10n.googleSignInUnavailable,
      },
    };
  }

  /// [localizedMessage] followed by any backend `errors` entries that aren't
  /// already part of it, one per line.
  String localizedMessageWithErrors(BuildContext context) {
    final message = localizedMessage(context);
    final details = (errors ?? const <String>[])
        .where((e) => e.trim().isNotEmpty && e != message)
        .toSet();
    if (details.isEmpty) return message;
    return [message, ...details].join('\n');
  }
}
