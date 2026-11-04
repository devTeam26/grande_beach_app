import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/images.dart';
import '../../../core/errors/failure.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/error_state.dart';
import '../../authentication/controllers/auth_providers.dart';
import '../../authentication/widgets/login_required_dialog.dart';
import '../../chalet_details/controllers/chalet_details_providers.dart';
import '../../shared/models/result_screen_args.dart';
import '../controllers/reservation_providers.dart';
import '../models/reservation_draft.dart';
import '../widgets/reservation_bottom_bar.dart';
import '../widgets/reservation_step1_dates.dart';
import '../widgets/reservation_step2_addons.dart';
import '../widgets/reservation_step3_price_preview.dart';
import '../widgets/reservation_step_indicator.dart';

/// Hosts the 3-step reservation wizard (Select Dates, Choose Add-ons,
/// Price Preview) for a single chalet, reached from the chalet details
/// screen's Reserve button.
class ReservationWizardScreen extends ConsumerStatefulWidget {
  const ReservationWizardScreen({super.key, required this.chaletId});

  final String chaletId;

  @override
  ConsumerState<ReservationWizardScreen> createState() =>
      _ReservationWizardScreenState();
}

class _ReservationWizardScreenState
    extends ConsumerState<ReservationWizardScreen> {
  int _currentStep = 0;

  // `ref` throws once the widget is disposed, so the container is captured
  // separately (it stays valid) for use from dispose().
  late final ProviderContainer _container;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _container = ProviderScope.containerOf(context, listen: false);
  }

  void _goToStep(int step) => setState(() => _currentStep = step);

  void _advance(int step, ReservationDraft draft) {
    _goToStep(step);
    if (step == 2) {
      ref
          .read(pricePreviewControllerProvider(widget.chaletId).notifier)
          .fetch(draft);
    }
  }

  /// Final Reserve action. Authenticated users submit exactly as before.
  /// Guests are asked to sign in first; Login is pushed on top of this
  /// still-mounted screen, so the draft (dates, guests, add-ons, special
  /// request, price preview) and the current step all stay in memory. The
  /// awaited push result is the pending intent: it resolves once, here, and
  /// nothing else needs clearing afterwards. The booking is never submitted
  /// automatically — the user taps Reserve again, avoiding duplicates.
  Future<void> _reserve(ReservationDraft draft) async {
    if (ref.read(sessionActiveProvider)) {
      ref.read(bookingSubmitControllerProvider.notifier).submit(draft);
      return;
    }

    final l10n = AppLocalizations.of(context);
    final wantsLogin = await LoginRequiredDialog.show(
      context,
      message: l10n.signInToCompleteReservation,
    );
    if (!wantsLogin || !mounted) return;

    final signedIn = await context.push<bool>('/login');
    if (signedIn != true || !mounted) return;

    // Back on the Price Preview step with the draft intact; refresh the
    // backend price for the now-authenticated account.
    final current = ref
        .read(reservationWizardControllerProvider(widget.chaletId))
        .valueOrNull;
    if (current != null) {
      ref
          .read(pricePreviewControllerProvider(widget.chaletId).notifier)
          .fetch(current);
    }
  }

  void _clearReservationState() {
    _container.invalidate(reservationWizardControllerProvider(widget.chaletId));
    _container.invalidate(pricePreviewControllerProvider(widget.chaletId));
    _container.invalidate(availabilityControllerProvider(widget.chaletId));
    _container.invalidate(bookingSubmitControllerProvider);
  }

  @override
  void dispose() {
    // Closing the wizard (back button, system back, or navigating away after
    // a successful booking) should always drop the in-progress draft. This
    // deliberately does NOT run when the user is only viewing the error
    // result screen and taps Try Again — that pops back to this same,
    // still-mounted screen, leaving the draft in place to edit.
    _clearReservationState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chaletAsync = ref.watch(chaletDetailsProvider(widget.chaletId));
    final draftAsync =
        ref.watch(reservationWizardControllerProvider(widget.chaletId));
    final submitAsync = ref.watch(bookingSubmitControllerProvider);

    ref.listen(bookingSubmitControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (success) {
          if (!success || previous?.valueOrNull == true) return;
          context.push(
            '/result',
            extra: ResultScreenArgs(
              imagePath: AppImages.check,
              title: l10n.bookingSuccessTitle,
              description: l10n.bookingSuccessMessage,
              primaryButtonLabel: l10n.backToHomeButton,
              primaryButtonAction: () => context.go('/home'),
            ),
          );
        },
        error: (error, _) {
          final description = error is Failure
              ? error.message
              : l10n.errorSubmittingBooking;
          final errorDetails = error is Failure &&
                  error.errors != null &&
                  error.errors!.isNotEmpty
              ? error.errors!.join('\n')
              : null;
          context.push(
            '/result',
            extra: ResultScreenArgs(
              imagePath: AppImages.cancel,
              title: l10n.bookingErrorTitle,
              description: description,
              errorDetails: errorDetails,
              primaryButtonLabel: l10n.tryAgainButton,
              primaryButtonAction: () => context.pop(),
            ),
          );
        },
      );
    });

    final stepTitles = [
      l10n.reservationStep1Title,
      l10n.reservationStep2Title,
      l10n.reservationStep3Title,
    ];
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          icon:  Icon(isAndroid ? Icons.arrow_back : Icons.arrow_back_ios_new,
),
          onPressed: () =>
              _currentStep > 0 ? _goToStep(_currentStep - 1) : context.pop(),
        ),
        title: Text(stepTitles[_currentStep]),
        centerTitle: true,
      ),
      body: chaletAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: ErrorState(
            message: l10n.errorLoadingChalets,
            onRetry: () =>
                ref.invalidate(chaletDetailsProvider(widget.chaletId)),
          ),
        ),
        data: (chalet) {
          return draftAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => Center(
              child: ErrorState(
                message: l10n.errorLoadingChalets,
                onRetry: () => ref.invalidate(
                  reservationWizardControllerProvider(widget.chaletId),
                ),
              ),
            ),
            data: (draft) {
              final canGoNext = switch (_currentStep) {
                0 => draft.isStep1Valid(chalet.maxGuests),
                1 => true,
                2 => draft.pricePreview != null,
                _ => false,
              };

              return Column(
                children: [
                  ReservationStepIndicator(
                    currentStep: _currentStep,
                    stepLabels: stepTitles,
                  ),
                  Expanded(
                    child: IndexedStack(
                      index: _currentStep,
                      children: [
                        ReservationStep1Dates(
                          draft: draft,
                          maxGuests: chalet.maxGuests,
                        ),
                        ReservationStep2AddOns(draft: draft),
                        ReservationStep3PricePreview(draft: draft),
                      ],
                    ),
                  ),
                  ReservationBottomBar(
                    currentStep: _currentStep,
                    canGoNext: canGoNext,
                    isLoading: _currentStep == 2 && submitAsync.isLoading,
                    label: _currentStep == 2 ? l10n.reserve : null,
                    onNext: () {
                      if (_currentStep == 2) {
                        _reserve(draft);
                        return;
                      }
                      _advance(_currentStep + 1, draft);
                    },
                    onBack: () => _goToStep(_currentStep - 1),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
