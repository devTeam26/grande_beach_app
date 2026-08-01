import 'package:flutter/widgets.dart';

/// Arguments for the generic [ResultScreen] — usable for any success/error
/// outcome across the app (verification, payments, bookings, etc), not just
/// the reservation wizard.
class ResultScreenArgs {
  const ResultScreenArgs({
    required this.imagePath,
    required this.title,
    required this.description,
    this.errorDetails,
    required this.primaryButtonLabel,
    required this.primaryButtonAction,
  });

  final String imagePath;
  final String title;
  final String description;

  /// The underlying error's own message (e.g. from the backend), shown
  /// alongside [description] so the user sees both the generic explanation
  /// and the specific reason. Null for success outcomes.
  final String? errorDetails;
  final String primaryButtonLabel;
  final VoidCallback primaryButtonAction;
}
