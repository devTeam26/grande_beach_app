import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/config/api_strings.dart';
import '../models/auth_session_model.dart';
import '../models/forgot_password_request_model.dart';
import '../models/google_login_request_model.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/reset_password_request_model.dart';
import 'auth_api_exception.dart';
import 'auth_service.dart';

class AuthServiceImpl implements AuthService {
  AuthServiceImpl(this._dio);

  final Dio _dio;

  @override
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiStrings.login,
      data: LoginRequestModel(email: email, password: password).toJson(),
    );

    final body = response.data!;
    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw AuthApiException(
        body['message'] as String? ?? 'Invalid credentials.',
      );
    }

    return AuthSessionModel.fromJson(body['data'] as Map<String, dynamic>);
  }

  @override
  Future<AuthSessionModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required String preferredLanguage,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiStrings.register,
      data: RegisterRequestModel(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        preferredLanguage: preferredLanguage,
      ).toJson(),
    );

    final body = response.data!;
    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw AuthApiException(
        body['message'] as String? ?? 'Registration failed.',
      );
    }

    return AuthSessionModel.fromJson(body['data'] as Map<String, dynamic>);
  }

  @override
  Future<AuthSessionModel> refresh({required String refreshToken}) async {
    debugPrint('[AUTH] POST ${ApiStrings.refresh}');
    final response = await _dio.post<Map<String, dynamic>>(
      ApiStrings.refresh,
      data: {'refreshToken': refreshToken},
    );

    final body = response.data!;
    final success = body['success'] as bool? ?? false;
    debugPrint(
      '[AUTH] ${ApiStrings.refresh} responded ${response.statusCode}, '
      'success=$success',
    );
    if (!success) {
      throw AuthApiException(
        body['message'] as String? ?? 'Session expired. Please sign in again.',
      );
    }

    return AuthSessionModel.fromJson(body['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiStrings.resetPassword,
      data: ResetPasswordRequestModel(
        email: email,
        token: token,
        newPassword: newPassword,
      ).toJson(),
    );

    final body = response.data!;
    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw AuthApiException(
        body['message'] as String? ?? 'Password reset failed.',
      );
    }
  }

  @override
  Future<AuthSessionModel> googleLogin({required String idToken}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiStrings.googleLogin,
      data: GoogleLoginRequestModel(idToken: idToken).toJson(),
    );

    final body = response.data!;
    if (body['success'] as bool? ?? false) {
      return AuthSessionModel.fromJson(body['data'] as Map<String, dynamic>);
    }
    throw _envelopeException(body);
  }

  @override
  Future<String> forgotPassword({required String email}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiStrings.forgotPassword,
      data: ForgotPasswordRequestModel(email: email).toJson(),
    );

    final body = response.data!;
    if (body['success'] as bool? ?? false) {
      return body['message'] as String? ?? '';
    }
    throw _envelopeException(body);
  }

  @override
  Future<void> deleteAccount() async {
    final response = await _dio.delete<Map<String, dynamic>>(
      ApiStrings.account,
    );

    // Some backends answer 204 No Content; only an explicit
    // `success: false` envelope counts as a failure.
    final body = response.data;
    if (body != null && body['success'] == false) {
      throw _envelopeException(body);
    }
  }

  /// Builds an [AuthApiException] from a `success: false` envelope. The
  /// message falls back to the first `errors` entry, then to empty (the
  /// repository substitutes the standard localized fallback).
  AuthApiException _envelopeException(Map<String, dynamic> body) {
    final rawErrors = body['errors'];
    final errors = rawErrors is List
        ? rawErrors
              .map((e) => e.toString())
              .where((e) => e.trim().isNotEmpty)
              .toList()
        : const <String>[];
    final message = body['message'];
    return AuthApiException(
      message is String && message.trim().isNotEmpty
          ? message
          : (errors.isNotEmpty ? errors.first : ''),
      errors: errors.isEmpty ? null : errors,
    );
  }

  @override
  Future<void> logout({required String accessToken}) async {
    await _dio.post<void>(
      ApiStrings.logout,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }
}
