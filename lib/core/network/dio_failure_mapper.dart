import 'package:dio/dio.dart';

import '../errors/failure.dart';

/// Maps a [DioException] (and the backend's standard error envelope) to a
/// [Failure] that the UI layer can render as a user-friendly message.
class DioFailureMapper {
  static Failure map(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure(
          'Unable to reach the server. Please try again.',
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return const UnknownFailure(
          'An unexpected error occurred. Please try again.',
        );
      case DioExceptionType.badResponse:
        return _mapBadResponse(exception);
    }
  }

  static Failure _mapBadResponse(DioException exception) {
    final statusCode = exception.response?.statusCode ?? 0;
    final data = exception.response?.data;
    final message = _extractMessage(data);

    if (statusCode == 401) {
      return UnauthorizedFailure(message ?? 'Invalid credentials.');
    }
    if (statusCode == 422 || statusCode == 400 || statusCode == 409) {
      return ValidationFailure(
        message ?? 'Please check your input and try again.',
        fieldErrors: _extractFieldErrors(data),
      );
    }
    if (statusCode >= 500) {
      return ServerFailure(
        message ?? 'Something went wrong on our end. Please try again later.',
      );
    }
    return UnknownFailure(message ?? 'An unexpected error occurred.');
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;

      final errors = data['errors'];
      if (errors is List && errors.isNotEmpty) {
        return errors.first.toString();
      }
    }
    return null;
  }

  static Map<String, List<String>>? _extractFieldErrors(dynamic data) {
    if (data is Map<String, dynamic>) {
      final errors = data['errors'];
      if (errors is Map<String, dynamic>) {
        return errors.map(
          (key, value) => MapEntry(
            key,
            (value as List).map((e) => e.toString()).toList(),
          ),
        );
      }
    }
    return null;
  }
}
