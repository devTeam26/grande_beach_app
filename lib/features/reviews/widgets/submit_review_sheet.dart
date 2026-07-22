import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/app_button.dart';
import '../controllers/reviews_providers.dart';
import 'rating_input.dart';

/// Bottom sheet collecting a star rating and comment, then calling
/// `/api/reviews` via [SubmitReviewController].
class SubmitReviewSheet extends ConsumerStatefulWidget {
  const SubmitReviewSheet({super.key, required this.bookingId});

  final String bookingId;

  static Future<void> show(BuildContext context, {required String bookingId}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SubmitReviewSheet(bookingId: bookingId),
    );
  }

  @override
  ConsumerState<SubmitReviewSheet> createState() => _SubmitReviewSheetState();
}

class _SubmitReviewSheetState extends ConsumerState<SubmitReviewSheet> {
  final _commentController = TextEditingController();
  int _rating = 0;
  String? _validationError;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final l10n = AppLocalizations.of(context);
    final comment = _commentController.text.trim();

    if (_rating == 0) {
      setState(() => _validationError = l10n.ratingRequiredError);
      return;
    }
    if (comment.isEmpty) {
      setState(() => _validationError = l10n.reviewCommentRequiredError);
      return;
    }
    setState(() => _validationError = null);

    final succeeded = await ref
        .read(submitReviewControllerProvider(widget.bookingId).notifier)
        .submit(rating: _rating, comment: comment);

    if (succeeded && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.reviewSubmittedMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final submitState =
        ref.watch(submitReviewControllerProvider(widget.bookingId));
    final serverError =
        submitState.hasError ? (submitState.error as Failure).message : null;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              l10n.submitReviewTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.submitReviewSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 16),
            RatingInput(
              rating: _rating,
              onChanged: (value) => setState(() => _rating = value),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.reviewCommentLabel,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: l10n.reviewCommentHint,
                errorText: _validationError ?? serverError,
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              label: l10n.submitReviewButton,
              isLoading: submitState.isLoading,
              onPressed: _onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
