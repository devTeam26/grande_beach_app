import 'dart:io';
import 'dart:typed_data';

import '../models/verification_status.dart';

abstract class VerificationService {
  /// Returns the backend's success message.
  Future<String> submitVerification({
    required String bookingId,
    required File idCard,
    required File photo,
    required Uint8List signatureBytes,
  });

  /// Calls `/api/Verification/my`.
  Future<VerificationStatusInfo> getMyVerificationStatus();
}
