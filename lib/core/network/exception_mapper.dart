import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../errors/failure.dart';
import 'dio_failure_mapper.dart';

/// Safety-net mapper for repository catch-all clauses: converts any
/// exception a network call can throw — including ones Dio doesn't wrap,
/// like a raw [SocketException] or [TimeoutException] — into a [Failure]
/// so the UI never sees a raw exception.
class ExceptionMapper {
  static Failure map(Object error) {
    if (error is DioException) return DioFailureMapper.map(error);
    if (error is SocketException || error is TimeoutException) {
      return const NetworkFailure(
        'Unable to reach the server. Please try again.',
      );
    }
    return const UnknownFailure(
      'An unexpected error occurred. Please try again.',
    );
  }
}
