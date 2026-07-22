import 'dart:io';
import 'dart:typed_data';

import '../../../core/utils/result.dart';
import '../models/verification_status.dart';

abstract class VerificationRepository {
  Future<Result<String>> submitVerification({
    required String bookingId,
    required File idCard,
    required File photo,
    required Uint8List signatureBytes,
  });

  /// Returns the cached status without a network call if one is already
  /// cached for this app session; otherwise fetches it once from
  /// `/api/Verification/my` and caches the result.
  Future<VerificationStatus> getStatus();

  /// Always calls `/api/Verification/my`, updates the cache, and returns
  /// the latest status. Use only where the freshest state is required
  /// (e.g. opening the Bookings screen).
  Future<VerificationStatus> refreshStatus();

  /// Rejection reason from the most recently cached verification record.
  String? get rejectionReason;

  /// Overwrites the cached status without a network call, e.g. right after
  /// a successful upload when the new status is already known.
  void updateStatus(VerificationStatus status, {String? rejectionReason});

  /// Drops the cached status, e.g. on logout.
  void clearCache();
}
