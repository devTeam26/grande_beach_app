import 'package:dio/dio.dart';

import '../../../core/errors/failure.dart';
import '../../../core/network/dio_failure_mapper.dart';
import '../../../core/network/exception_mapper.dart';
import '../../../core/network/network_info.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../core/utils/result.dart';
import '../../authentication/models/user_model.dart';
import '../../authentication/services/auth_api_exception.dart';
import '../services/profile_service.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required ProfileService profileService,
    required NetworkInfo networkInfo,
    required LocalStorageService localStorage,
  })  : _profileService = profileService,
        _networkInfo = networkInfo,
        _localStorage = localStorage;

  final ProfileService _profileService;
  final NetworkInfo _networkInfo;
  final LocalStorageService _localStorage;

  @override
  Future<Result<UserModel>> getProfile() async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure('No internet connection.'),
      );
    }
    try {
      final user = await _profileService.getProfile();
      await _localStorage.saveUserProfile(user.toJson());
      return Success(user);
    } on AuthApiException catch (e) {
      return ResultFailure(ServerFailure(e.message));
    } on DioException catch (e) {
      return ResultFailure(DioFailureMapper.map(e));
    } catch (e) {
      return ResultFailure(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Result<UserModel>> updateProfile({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String preferredLanguage,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure('No internet connection.'),
      );
    }
    try {
      final user = await _profileService.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        preferredLanguage: preferredLanguage,
      );
      await _localStorage.saveUserProfile(user.toJson());
      return Success(user);
    } on AuthApiException catch (e) {
      return ResultFailure(ValidationFailure(e.message));
    } on DioException catch (e) {
      return ResultFailure(DioFailureMapper.map(e));
    } catch (e) {
      return ResultFailure(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure('No internet connection.'),
      );
    }
    try {
      await _profileService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Success(null);
    } on AuthApiException catch (e) {
      return ResultFailure(ValidationFailure(e.message));
    } on DioException catch (e) {
      return ResultFailure(DioFailureMapper.map(e));
    } catch (e) {
      return ResultFailure(ExceptionMapper.map(e));
    }
  }
}
