import 'package:flutter/material.dart';

import '../../../core/widgets/app_button.dart';
import '../models/result_screen_args.dart';

/// Generic full-screen success/error outcome — image, title, description,
/// and a single primary action. Reusable across any flow that ends in a
/// pass/fail result (verification, payments, bookings, etc). Reached via
/// `context.push('/result', extra: ResultScreenArgs(...))`.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.args});

  final ResultScreenArgs args;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(args.imagePath, width: 120, height: 120),
                const SizedBox(height: 24),
                Text(
                  args.title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  args.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
                if (args.errorDetails != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    args.errorDetails!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                AppButton(
                  label: args.primaryButtonLabel,
                  onPressed: args.primaryButtonAction,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
