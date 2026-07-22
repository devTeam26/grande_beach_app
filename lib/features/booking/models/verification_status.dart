/// Verification state for the current app session, cached by
/// [VerificationRepository] so `/api/Verification/my` isn't re-fetched on
/// every reservation attempt.
enum VerificationStatus {
  /// Never checked in this app session.
  unknown,

  /// Documents submitted, awaiting admin review.
  pending,

  /// Admin rejected the documents; must be resubmitted.
  rejected,

  /// Verification completed successfully.
  approved,
}

VerificationStatus verificationStatusFromApi(String? value) {
  switch (value?.toLowerCase()) {
    case 'approved':
      return VerificationStatus.approved;
    case 'pending':
      return VerificationStatus.pending;
    case 'rejected':
      return VerificationStatus.rejected;
    default:
      return VerificationStatus.unknown;
  }
}

/// Parsed payload from `/api/Verification/my`.
class VerificationStatusInfo {
  const VerificationStatusInfo({required this.status, this.rejectionReason});

  final VerificationStatus status;
  final String? rejectionReason;

  factory VerificationStatusInfo.fromJson(Map<String, dynamic> json) {
    return VerificationStatusInfo(
      status: verificationStatusFromApi(json['status'] as String?),
      rejectionReason: json['rejectionReason'] as String?,
    );
  }
}
