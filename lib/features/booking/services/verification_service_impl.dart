import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../core/config/api_strings.dart';
import '../models/verification_status.dart';
import 'verification_api_exception.dart';
import 'verification_service.dart';

class VerificationServiceImpl implements VerificationService {
  VerificationServiceImpl(this._dio);

  final Dio _dio;

  @override
  Future<String> submitVerification({
    required String bookingId,
    required File idCard,
    required File photo,
    required Uint8List signatureBytes,
  }) async {
    final formData = FormData.fromMap({
      'IdCard': await MultipartFile.fromFile(idCard.path),
      'Photo': await MultipartFile.fromFile(photo.path),
      'SignatureData': base64Encode(signatureBytes),
      'BookingId': bookingId,
    });

    final response = await _dio.post<Map<String, dynamic>>(
      ApiStrings.verification,
      data: formData,
    );

    final body = response.data!;
    final success = body['success'] as bool? ?? false;
    final message = body['message'] as String?;
    if (!success) {
      throw VerificationApiException(
        message ?? 'Failed to submit verification.',
      );
    }

    return message ?? 'Verification submitted successfully.';
  }

  @override
  Future<VerificationStatusInfo> getMyVerificationStatus() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiStrings.myVerification,
    );

    final body = response.data!;
    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw VerificationApiException(
        body['message'] as String? ?? 'Failed to load verification status.',
      );
    }

    final data = body['data'] as Map<String, dynamic>?;
    if (data == null) {
      return const VerificationStatusInfo(status: VerificationStatus.unknown);
    }
    return VerificationStatusInfo.fromJson(data);
  }
}
