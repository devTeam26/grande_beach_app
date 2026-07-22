import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../core/errors/failure.dart';
import '../../../core/network/dio_failure_mapper.dart';
import '../../../core/network/exception_mapper.dart';
import '../../../core/network/network_info.dart';
import '../../../core/utils/result.dart';
import '../models/verification_status.dart';
import '../services/verification_api_exception.dart';
import '../services/verification_service.dart';
import 'verification_repository.dart';

class VerificationRepositoryImpl implements VerificationRepository {
  VerificationRepositoryImpl({
    required VerificationService verificationService,
    required NetworkInfo networkInfo,
  })  : _verificationService = verificationService,
        _networkInfo = networkInfo;

  final VerificationService _verificationService;
  final NetworkInfo _networkInfo;

  VerificationStatus? _cachedStatus;
  String? _rejectionReason;

  @override
  String? get rejectionReason => _rejectionReason;

  @override
  Future<Result<String>> submitVerification({
    required String bookingId,
    required File idCard,
    required File photo,
    required Uint8List signatureBytes,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure(
          'No internet connection. Please check your network and try again.',
        ),
      );
    }

    try {
      final message = await _verificationService.submitVerification(
        bookingId: bookingId,
        idCard: idCard,
        photo: photo,
        signatureBytes: signatureBytes,
      );
      return Success(message);
    } on VerificationApiException catch (e) {
      return ResultFailure(ServerFailure(e.message));
    } on DioException catch (e) {
      return ResultFailure(DioFailureMapper.map(e));
    } catch (e) {
      return ResultFailure(ExceptionMapper.map(e));
    }
  }

  @override
  Future<VerificationStatus> getStatus() async {
    final cached = _cachedStatus;
    if (cached != null) return cached;
    return refreshStatus();
  }

  @override
  Future<VerificationStatus> refreshStatus() async {
    final result = await _fetchStatus();
    return result.fold(
      (failure) => _cachedStatus ?? VerificationStatus.unknown,
      (info) {
        _cachedStatus = info.status;
        _rejectionReason = info.rejectionReason;
        return info.status;
      },
    );
  }

  @override
  void updateStatus(VerificationStatus status, {String? rejectionReason}) {
    _cachedStatus = status;
    _rejectionReason = rejectionReason;
  }

  @override
  void clearCache() {
    _cachedStatus = null;
    _rejectionReason = null;
  }

  Future<Result<VerificationStatusInfo>> _fetchStatus() async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure(
          'No internet connection. Please check your network and try again.',
        ),
      );
    }

    try {
      final info = await _verificationService.getMyVerificationStatus();
      return Success(info);
    } on VerificationApiException catch (e) {
      return ResultFailure(ServerFailure(e.message));
    } on DioException catch (e) {
      return ResultFailure(DioFailureMapper.map(e));
    } catch (e) {
      return ResultFailure(ExceptionMapper.map(e));
    }
  }
}
