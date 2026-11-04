import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/config/api_strings.dart';
import '../../../core/errors/failure.dart';
import '../../../core/network/dio_failure_mapper.dart';
import '../../../core/network/exception_mapper.dart';
import '../../../core/network/network_info.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../core/utils/result.dart';
import '../models/auth_session_model.dart';
import '../models/user_model.dart';
import '../services/auth_api_exception.dart';
import '../services/auth_service.dart';
import '../services/google_auth_exception.dart';
import '../services/google_sign_in_service.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthService authService,
    required GoogleSignInService googleSignInService,
    required NetworkInfo networkInfo,
    required SecureStorageService secureStorage,
    required LocalStorageService localStorage,
  }) : _authService = authService,
       _googleSignInService = googleSignInService,
       _networkInfo = networkInfo,
       _secureStorage = secureStorage,
       _localStorage = localStorage;

  final AuthService _authService;
  final GoogleSignInService _googleSignInService;
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
      final session = await _authService.login(
        email: email,
        password: password,
      );
      return _startSession(session);
    } on AuthApiException catch (e) {
      return ResultFailure(UnauthorizedFailure(e.message));
    } on DioException catch (e) {
      return ResultFailure(DioFailureMapper.map(e));
    } catch (e) {
      return ResultFailure(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Result<UserModel>> loginWithGoogle() async {
    // Checked before the account picker so the user isn't asked to pick an
    // account for a request that can't be sent.
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure(
          'No internet connection. Please check your network and try again.',
        ),
      );
    }

    final String idToken;
    try {
      idToken = await _googleSignInService.getIdToken();
    } on GoogleAuthException catch (e) {
      if (e.reason != GoogleSignInFailureReason.cancelled) {
        debugPrint('[AUTH] Google Sign-In ${e.reason.name}: ${e.debugMessage}');
      }
      return ResultFailure(
        GoogleSignInFailure(
          'Google Sign-In ${e.reason.name}.',
          reason: e.reason,
        ),
      );
    }

    Result<UserModel> result;
    try {
      final session = await _authService.googleLogin(idToken: idToken);
      result = await _startSession(session);
    } on AuthApiException catch (e) {
      result = ResultFailure(_envelopeFailure(e));
    } on DioException catch (e) {
      final failure = DioFailureMapper.map(e);
      // A 401 here means the backend rejected the Google token, not a wrong
      // password — show the backend's reason instead of "Invalid credentials".
      result = ResultFailure(
        failure is UnauthorizedFailure
            ? ValidationFailure(failure.message)
            : failure,
      );
    } catch (e) {
      result = ResultFailure(ExceptionMapper.map(e));
    }

    // Drop the cached Google account after a backend rejection so the next
    // attempt shows the picker again (e.g. to choose another account).
    if (result.isFailure) await _googleSignInService.signOut();
    return result;
  }

  /// Persists a freshly issued session (tokens in secure storage, profile in
  /// Hive). Shared by every sign-in method so they end in identical state.
  Future<Result<UserModel>> _startSession(AuthSessionModel session) async {
    final user = session.user;
    if (user == null) {
      return const ResultFailure(
        ServerFailure('Login failed. Please try again.'),
      );
    }

    await _secureStorage.saveSession(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      expiresAt: session.expiresAt,
    );
    await _localStorage.saveUserProfile(user.toJson());

    return Success(user);
  }

  /// Maps a `success: false` envelope to a failure that shows the backend's
  /// message, or the standard fallback when it sent none.
  Failure _envelopeFailure(AuthApiException e) {
    if (e.message.isEmpty) {
      return const UnknownFailure(
        'An unexpected error occurred. Please try again.',
      );
    }
    return ValidationFailure(e.message, errors: e.errors);
  }

  @override
  Future<Result<String>> forgotPassword({required String email}) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure(
          'No internet connection. Please check your network and try again.',
        ),
      );
    }

    try {
      final message = await _authService.forgotPassword(email: email);
      return Success(message);
    } on AuthApiException catch (e) {
      return ResultFailure(_envelopeFailure(e));
    } on DioException catch (e) {
      return ResultFailure(DioFailureMapper.map(e));
    } catch (e) {
      return ResultFailure(ExceptionMapper.map(e));
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

      final user = session.user;
      if (user == null) {
        return const ResultFailure(
          ValidationFailure('Registration failed. Please try again.'),
        );
      }

      // Registration must not auto-login: tokens are intentionally discarded
      // here so the user is forced to sign in with their new credentials.
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
  Future<Result<void>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure(
          'No internet connection. Please check your network and try again.',
        ),
      );
    }

    try {
      await _authService.resetPassword(
        email: email,
        token: token,
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

  @override
  Future<bool> hasActiveSession() => _secureStorage.hasValidSession();

  @override
  Future<Result<void>> refreshSession() async {
    debugPrint('[AUTH] refreshSession(): calling ${ApiStrings.refresh}');
    final refreshToken = await _secureStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      // No stored session at all — nothing to refresh.
      debugPrint('[AUTH] refreshSession(): no stored refresh token found');
      await _clearLocalSession();
      return const ResultFailure(UnauthorizedFailure('No active session.'));
    }

    // Offline: don't force a re-login the user can't complete. Keep the
    // stored session; the 401 interceptor handles expiry once back online.
    if (!await _networkInfo.isConnected) {
      debugPrint('[AUTH] refreshSession(): offline, keeping stored session');
      return const Success(null);
    }

    try {
      final session = await _authService.refresh(refreshToken: refreshToken);

      await _secureStorage.saveSession(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
        expiresAt: session.expiresAt,
      );
      if (session.user != null) {
        await _localStorage.saveUserProfile(session.user!.toJson());
      }
      debugPrint(
        '[AUTH] refreshSession(): success, new tokens saved '
        '(expiresAt=${session.expiresAt})',
      );
      return const Success(null);
    } on AuthApiException catch (e) {
      // Backend rejected the refresh token (invalid/expired) — force login.
      debugPrint(
        '[AUTH] refreshSession(): rejected by backend -> ${e.message}',
      );
      await _clearLocalSession();
      return ResultFailure(UnauthorizedFailure(e.message));
    } on DioException catch (e) {
      // A 401 means the refresh token is no longer valid — force login.
      if (e.response?.statusCode == 401) {
        debugPrint(
          '[AUTH] refreshSession(): 401 from ${ApiStrings.refresh}, '
          'refresh token invalid/expired -> clearing session',
        );
        await _clearLocalSession();
        return const ResultFailure(
          UnauthorizedFailure('Session expired. Please sign in again.'),
        );
      }
      // Transient network/server error: keep the session and let the user in;
      // they can retry authenticated requests once connectivity recovers.
      debugPrint(
        '[AUTH] refreshSession(): transient error (${e.response?.statusCode}, '
        '${e.message}), keeping stored session',
      );
      return const Success(null);
    } catch (e) {
      // Unexpected error: fail safe by keeping the existing session.
      debugPrint('[AUTH] refreshSession(): unexpected error -> $e');
      return const Success(null);
    }
  }

  Future<void> _clearLocalSession() async {
    await _secureStorage.clearSession();
    await _localStorage.clearUserProfile();
  }

  @override
  Future<Result<void>> deleteAccount() async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure(
          'No internet connection. Please check your network and try again.',
        ),
      );
    }

    try {
      await _authService.deleteAccount();
    } on AuthApiException catch (e) {
      return ResultFailure(_envelopeFailure(e));
    } on DioException catch (e) {
      return ResultFailure(DioFailureMapper.map(e));
    } catch (e) {
      return ResultFailure(ExceptionMapper.map(e));
    }

    // The account no longer exists server-side, so there is no session to
    // invalidate — just drop everything held locally.
    await _clearLocalSession();
    await _googleSignInService.signOut();
    return const Success(null);
  }

  @override
  Future<Result<void>> logout() async {
    // Best-effort: call the server but always clear local state regardless.
    try {
      final token = await _secureStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        await _authService.logout(accessToken: token);
      }
    } catch (_) {
      // Server invalidation failure is non-fatal; local session is cleared below.
    }
    // So the next Google sign-in offers the account picker again.
    await _googleSignInService.signOut();

    await _secureStorage.clearSession();
    await _localStorage.clearUserProfile();
    return const Success(null);
  }
}
