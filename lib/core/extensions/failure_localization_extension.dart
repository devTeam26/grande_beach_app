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
    };
  }
}
