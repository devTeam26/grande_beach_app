import 'dart:io';
import 'dart:typed_data';

/// The in-progress set of documents collected on [VerificationScreen] before
/// they're submitted to `/api/Verification`.
class VerificationDraft {
  const VerificationDraft({
    this.idCardImage,
    this.personalPhoto,
    this.signatureBytes,
  });

  final File? idCardImage;
  final File? personalPhoto;
  final Uint8List? signatureBytes;

  bool get isComplete =>
      idCardImage != null && personalPhoto != null && signatureBytes != null;

  VerificationDraft copyWith({
    File? idCardImage,
    bool clearIdCardImage = false,
    File? personalPhoto,
    bool clearPersonalPhoto = false,
    Uint8List? signatureBytes,
    bool clearSignatureBytes = false,
  }) {
    return VerificationDraft(
      idCardImage: clearIdCardImage ? null : (idCardImage ?? this.idCardImage),
      personalPhoto:
          clearPersonalPhoto ? null : (personalPhoto ?? this.personalPhoto),
      signatureBytes: clearSignatureBytes
          ? null
          : (signatureBytes ?? this.signatureBytes),
    );
  }
}
