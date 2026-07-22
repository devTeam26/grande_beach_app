import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:signature/signature.dart';

import '../../../core/config/images.dart';
import '../../../core/errors/failure.dart';
import '../../../core/extensions/failure_localization_extension.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/app_button.dart';
import '../../shared/models/result_screen_args.dart';
import '../controllers/verification_providers.dart';
import '../models/verification_status.dart';
import '../widgets/signature_pad_card.dart';
import '../widgets/upload_card.dart';
import '../widgets/verification_rejected_banner.dart';

/// Lets the guest submit identity-verification documents (ID card, personal
/// photo, signature) for a pending booking, reached from the "Verify"
/// button on [BookingCard]. Posts to `/api/Verification`.
class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  ConsumerState<VerificationScreen> createState() =>
      _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  late final SignatureController _signatureController;

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penStrokeWidth: 2.5,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
      onDrawEnd: _exportSignature,
    );
  }

  Future<void> _exportSignature() async {
    if (_signatureController.isEmpty) {
      if (mounted) {
        ref.read(verificationDraftControllerProvider.notifier).clearSignature();
      }
      return;
    }
    final bytes = await _signatureController.toPngBytes();
    if (bytes != null && mounted) {
      ref.read(verificationDraftControllerProvider.notifier).setSignature(bytes);
    }
  }

  void _undoSignature() {
    _signatureController.undo();
    _exportSignature();
  }

  void _clearSignature() {
    _signatureController.clear();
    ref.read(verificationDraftControllerProvider.notifier).clearSignature();
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final draft = ref.watch(verificationDraftControllerProvider);
    final controller = ref.read(verificationDraftControllerProvider.notifier);
    final submitState = ref.watch(verificationSubmitControllerProvider);
    final isRejected = ref.watch(verificationStatusProvider).valueOrNull ==
        VerificationStatus.rejected;
    final rejectionReason =
        ref.read(verificationRepositoryProvider).rejectionReason;

    ref.listen(verificationSubmitControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (message) {
          if (message == null) return;
          context.push(
            '/result',
            extra: ResultScreenArgs(
              imagePath: AppImages.check,
              title: l10n.verificationSubmittedTitle,
              description: l10n.verificationSubmittedMessage,
              primaryButtonLabel: l10n.backToHomeButton,
              primaryButtonAction: () => context.go('/home'),
            ),
          );
        },
        error: (error, _) {
          final errorDetails =
              error is Failure ? error.localizedMessage(context) : null;
          context.push(
            '/result',
            extra: ResultScreenArgs(
              imagePath: AppImages.cancel,
              title: l10n.verificationErrorTitle,
              description: l10n.errorSubmittingVerification,
              errorDetails: errorDetails,
              primaryButtonLabel: l10n.tryAgainButton,
              primaryButtonAction: () => context.pop(),
            ),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.verificationScreenTitle),
        centerTitle: true,
        forceMaterialTransparency: true,
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: GestureDetector(
          onTap: !draft.isComplete
              ? () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.verificationIncompleteMessage)),
                  )
              : null,
          child: AppButton(
            label: l10n.submitVerificationButton,
            isLoading: submitState.isLoading,
            onPressed: draft.isComplete
                ? () => ref
                    .read(verificationSubmitControllerProvider.notifier)
                    .submit(bookingId: widget.bookingId, draft: draft)
                : null,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.verificationSubtitle,
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
            if (isRejected && rejectionReason != null) ...[
              VerificationRejectedBanner(reason: rejectionReason),
              const SizedBox(height: 20),
            ],
            const SizedBox(height: 20),
            UploadCard(
              icon: LucideIcons.creditCard,
              title: l10n.idCardTitle,
              subtitle: l10n.idCardSubtitle,
              image: draft.idCardImage,
              onPicked: controller.setIdCard,
              onRemove: controller.removeIdCard,
            ),
            UploadCard(
              icon: LucideIcons.userCircle,
              title: l10n.personalPhotoTitle,
              subtitle: l10n.personalPhotoSubtitle,
              image: draft.personalPhoto,
              onPicked: controller.setPersonalPhoto,
              onRemove: controller.removePersonalPhoto,
            ),
            SignaturePadCard(
              controller: _signatureController,
              onClear: _clearSignature,
              onUndo: _undoSignature,
            ),
          ],
        ),
      ),
    );
  }
}
