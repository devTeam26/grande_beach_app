import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../models/verification_draft.dart';
import '../models/verification_status.dart';
import '../repositories/verification_repository.dart';
import '../repositories/verification_repository_impl.dart';
import '../services/verification_service.dart';
import '../services/verification_service_impl.dart';

final verificationServiceProvider = Provider<VerificationService>((ref) {
  return VerificationServiceImpl(ref.watch(apiClientProvider).dio);
});

final verificationRepositoryProvider = Provider<VerificationRepository>((ref) {
  return VerificationRepositoryImpl(
    verificationService: ref.watch(verificationServiceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

/// Session-cached verification status, backed by [VerificationRepository].
/// Kept alive for the whole app session (not `autoDispose`) so widgets on
/// different screens (booking cards, booking details, the verification
/// screen) all observe the same cached value instead of re-fetching it.
class VerificationStatusNotifier extends AsyncNotifier<VerificationStatus> {
  @override
  Future<VerificationStatus> build() {
    return ref.read(verificationRepositoryProvider).getStatus();
  }

  /// Forces a fresh `/api/Verification/my` call. Call this only where the
  /// latest state is required, e.g. opening the Bookings screen.
  Future<void> refresh() async {
    final status = await ref.read(verificationRepositoryProvider).refreshStatus();
    state = AsyncData(status);
  }

  /// Called right after a successful upload: the new status is already
  /// known, so this updates the cache without another network call.
  void markPending() {
    ref.read(verificationRepositoryProvider).updateStatus(VerificationStatus.pending);
    state = const AsyncData(VerificationStatus.pending);
  }
}

final verificationStatusProvider =
    AsyncNotifierProvider<VerificationStatusNotifier, VerificationStatus>(
  VerificationStatusNotifier.new,
);

/// UI-only state for the three items picked/drawn on [VerificationScreen].
/// `autoDispose` so the draft (and any picked files) is dropped as soon as
/// the screen is left, without needing manual cleanup.
class VerificationDraftController
    extends AutoDisposeNotifier<VerificationDraft> {
  @override
  VerificationDraft build() => const VerificationDraft();

  void setIdCard(File file) => state = state.copyWith(idCardImage: file);

  void removeIdCard() => state = state.copyWith(clearIdCardImage: true);

  void setPersonalPhoto(File file) =>
      state = state.copyWith(personalPhoto: file);

  void removePersonalPhoto() =>
      state = state.copyWith(clearPersonalPhoto: true);

  void setSignature(Uint8List bytes) =>
      state = state.copyWith(signatureBytes: bytes);

  void clearSignature() => state = state.copyWith(clearSignatureBytes: true);
}

final verificationDraftControllerProvider = AutoDisposeNotifierProvider<
    VerificationDraftController, VerificationDraft>(
  VerificationDraftController.new,
);

/// Submits the completed [VerificationDraft] for a booking, guarding against
/// duplicate in-flight requests. Holds the backend's success message on
/// completion.
class VerificationSubmitController extends AutoDisposeAsyncNotifier<String?> {
  @override
  Future<String?> build() async => null;

  Future<void> submit({
    required String bookingId,
    required VerificationDraft draft,
  }) async {
    if (state.isLoading) return;
    if (!draft.isComplete) return;

    state = const AsyncLoading();

    final result =
        await ref.read(verificationRepositoryProvider).submitVerification(
              bookingId: bookingId,
              idCard: draft.idCardImage!,
              photo: draft.personalPhoto!,
              signatureBytes: draft.signatureBytes!,
            );

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (message) {
        // The upload succeeded, so the new status is already known — update
        // the cache directly instead of calling `/api/Verification/my` again.
        ref.read(verificationStatusProvider.notifier).markPending();
        return AsyncData(message);
      },
    );
  }
}

final verificationSubmitControllerProvider = AutoDisposeAsyncNotifierProvider<
    VerificationSubmitController, String?>(
  VerificationSubmitController.new,
);
