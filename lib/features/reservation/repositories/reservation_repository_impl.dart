import 'package:dio/dio.dart';

import '../../../core/errors/failure.dart';
import '../../../core/network/dio_failure_mapper.dart';
import '../../../core/network/exception_mapper.dart';
import '../../../core/network/network_info.dart';
import '../../../core/utils/result.dart';
import '../models/add_on.dart';
import '../models/chalet_availability.dart';
import '../models/price_preview_result.dart';
import '../models/selected_add_on.dart';
import '../services/reservation_api_exception.dart';
import '../services/reservation_service.dart';
import 'reservation_repository.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  ReservationRepositoryImpl({
    required ReservationService reservationService,
    required NetworkInfo networkInfo,
  })  : _reservationService = reservationService,
        _networkInfo = networkInfo;

  final ReservationService _reservationService;
  final NetworkInfo _networkInfo;

  @override
  Future<Result<List<AddOn>>> fetchAddOns() async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure(
          'No internet connection. Please check your network and try again.',
        ),
      );
    }

    try {
      final addOns = await _reservationService.fetchAddOns();
      return Success(addOns);
    } on ReservationApiException catch (e) {
      return ResultFailure(ServerFailure(e.message, errors: e.errors));
    } on DioException catch (e) {
      return ResultFailure(DioFailureMapper.map(e));
    } catch (e) {
      return ResultFailure(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Result<ChaletAvailability>> fetchAvailability({
    required String chaletId,
    required DateTime from,
    required DateTime to,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure(
          'No internet connection. Please check your network and try again.',
        ),
      );
    }

    try {
      final availability = await _reservationService.fetchAvailability(
        chaletId: chaletId,
        from: from,
        to: to,
      );
      return Success(availability);
    } on ReservationApiException catch (e) {
      return ResultFailure(ServerFailure(e.message, errors: e.errors));
    } on DioException catch (e) {
      return ResultFailure(DioFailureMapper.map(e));
    } catch (e) {
      return ResultFailure(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Result<PricePreviewResult>> fetchPricePreview({
    required String chaletId,
    required String guestFirstName,
    required String guestLastName,
    required String guestEmail,
    required String guestPhone,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int guestCount,
    required List<SelectedAddOn> addOns,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure(
          'No internet connection. Please check your network and try again.',
        ),
      );
    }

    try {
      final preview = await _reservationService.fetchPricePreview(
        chaletId: chaletId,
        guestFirstName: guestFirstName,
        guestLastName: guestLastName,
        guestEmail: guestEmail,
        guestPhone: guestPhone,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
        guestCount: guestCount,
        addOns: addOns,
      );
      return Success(preview);
    } on ReservationApiException catch (e) {
      return ResultFailure(ServerFailure(e.message, errors: e.errors));
    } on DioException catch (e) {
      return ResultFailure(DioFailureMapper.map(e));
    } catch (e) {
      return ResultFailure(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Result<void>> createBooking({
    required String chaletId,
    required String guestFirstName,
    required String guestLastName,
    required String guestEmail,
    required String guestPhone,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int guestCount,
    required List<SelectedAddOn> addOns,
    String? specialRequests,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure(
          'No internet connection. Please check your network and try again.',
        ),
      );
    }

    try {
      await _reservationService.createBooking(
        chaletId: chaletId,
        guestFirstName: guestFirstName,
        guestLastName: guestLastName,
        guestEmail: guestEmail,
        guestPhone: guestPhone,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
        guestCount: guestCount,
        addOns: addOns,
        specialRequests: specialRequests,
      );
      return const Success(null);
    } on ReservationApiException catch (e) {
      return ResultFailure(ServerFailure(e.message, errors: e.errors));
    } on DioException catch (e) {
      return ResultFailure(DioFailureMapper.map(e));
    } catch (e) {
      return ResultFailure(ExceptionMapper.map(e));
    }
  }
}
