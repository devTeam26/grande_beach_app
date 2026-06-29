import 'package:dio/dio.dart';

import '../../../core/errors/failure.dart';
import '../../../core/network/dio_failure_mapper.dart';
import '../../../core/network/network_info.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../core/utils/result.dart';
import '../models/user_model.dart';
import '../services/auth_api_exception.dart';
import '../services/auth_service.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthService authService,
    required NetworkInfo networkInfo,
    required SecureStorageService secureStorage,
    required LocalStorageService localStorage,
  })  : _authService = authService,
        _networkInfo = networkInfo,
        _secureStorage = secureStorage,
        _localStorage = localStorage;

  final AuthService _authService;
  final NetworkInfo _networkInfo;
  final SecureStorageService _secureStorage;
  final LocalStorageService _localStorage;

  @override
  Future<Result<UserModel>> login({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure(
          'No internet connection. Please check your network and try again.',
        ),
      );
    }

    try {
      final session = await _authService.login(email: email, password: password);

      await _secureStorage.saveSession(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
        expiresAt: session.expiresAt,
      );
      await _localStorage.saveUserProfile(session.user.toJson());

      return Success(session.user);
    } on AuthApiException catch (e) {
      return ResultFailure(UnauthorizedFailure(e.message));
    } on DioException catch (e) {
      return ResultFailure(DioFailureMapper.map(e));
    }
  }

  @override
  Future<Result<UserModel>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required String preferredLanguage,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure(
          'No internet connection. Please check your network and try again.',
        ),
      );
    }

    try {
      final session = await _authService.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        preferredLanguage: preferredLanguage,
      );

      // Registration must not auto-login: tokens are intentionally discarded
      // here so the user is forced to sign in with their new credentials.
      return Success(session.user);
    } on AuthApiException catch (e) {
      return ResultFailure(ValidationFailure(e.message));
    } on DioException catch (e) {
      return ResultFailure(DioFailureMapper.map(e));
    }
  }

  @override
  Future<bool> hasActiveSession() => _secureStorage.hasValidSession();
}
