import 'package:dio/dio.dart';

import '../../../core/errors/failure.dart';
import '../../../core/network/dio_failure_mapper.dart';
import '../../../core/network/exception_mapper.dart';
import '../../../core/network/network_info.dart';
import '../../../core/utils/result.dart';
import '../models/booking.dart';
import '../models/bookings_page.dart';
import '../services/bookings_api_exception.dart';
import '../services/bookings_service.dart';
import 'bookings_repository.dart';

class BookingsRepositoryImpl implements BookingsRepository {
  BookingsRepositoryImpl({
    required BookingsService bookingsService,
    required NetworkInfo networkInfo,
  })  : _bookingsService = bookingsService,
        _networkInfo = networkInfo;

  final BookingsService _bookingsService;
  final NetworkInfo _networkInfo;

  @override
  Future<Result<BookingsPage>> fetchMyBookings({
    required int pageNumber,
    required int pageSize,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure(
          'No internet connection. Please check your network and try again.',
        ),
      );
    }

    try {
      final page = await _bookingsService.fetchMyBookings(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return Success(page);
    } on BookingsApiException catch (e) {
      return ResultFailure(ServerFailure(e.message));
    } on DioException catch (e) {
      return ResultFailure(DioFailureMapper.map(e));
    } catch (e) {
      return ResultFailure(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Result<Booking>> fetchBookingById(String id) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure(
          'No internet connection. Please check your network and try again.',
        ),
      );
    }

    try {
      final booking = await _bookingsService.fetchBookingById(id);
      return Success(booking);
    } on BookingsApiException catch (e) {
      return ResultFailure(ServerFailure(e.message));
    } on DioException catch (e) {
      return ResultFailure(DioFailureMapper.map(e));
    } catch (e) {
      return ResultFailure(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Result<void>> cancelBooking({
    required String id,
    required String reason,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure(
          'No internet connection. Please check your network and try again.',
        ),
      );
    }

    try {
      await _bookingsService.cancelBooking(id: id, reason: reason);
      return const Success(null);
    } on BookingsApiException catch (e) {
      return ResultFailure(ServerFailure(e.message));
    } on DioException catch (e) {
      return ResultFailure(DioFailureMapper.map(e));
    } catch (e) {
      return ResultFailure(ExceptionMapper.map(e));
    }
  }
}
