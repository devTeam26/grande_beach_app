import 'package:dio/dio.dart';

import '../../../core/errors/failure.dart';
import '../../../core/network/dio_failure_mapper.dart';
import '../../../core/network/exception_mapper.dart';
import '../../../core/network/network_info.dart';
import '../../../core/utils/result.dart';
import '../models/reviews_page.dart';
import '../services/reviews_api_exception.dart';
import '../services/reviews_service.dart';
import 'reviews_repository.dart';

class ReviewsRepositoryImpl implements ReviewsRepository {
  ReviewsRepositoryImpl({
    required ReviewsService reviewsService,
    required NetworkInfo networkInfo,
  })  : _reviewsService = reviewsService,
        _networkInfo = networkInfo;

  final ReviewsService _reviewsService;
  final NetworkInfo _networkInfo;

  @override
  Future<Result<ReviewsPage>> fetchReviews({
    required String chaletId,
    required int pageNumber,
    required int pageSize,
    int? rating,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure(
          'No internet connection. Please check your network and try again.',
        ),
      );
    }

    try {
      final page = await _reviewsService.fetchReviews(
        chaletId: chaletId,
        pageNumber: pageNumber,
        pageSize: pageSize,
        rating: rating,
      );
      return Success(page);
    } on ReviewsApiException catch (e) {
      return ResultFailure(ServerFailure(e.message));
    } on DioException catch (e) {
      return ResultFailure(DioFailureMapper.map(e));
    } catch (e) {
      return ResultFailure(ExceptionMapper.map(e));
    }
  }

  @override
  Future<Result<void>> submitReview({
    required String bookingId,
    required int rating,
    required String comment,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure(
          'No internet connection. Please check your network and try again.',
        ),
      );
    }

    try {
      await _reviewsService.submitReview(
        bookingId: bookingId,
        rating: rating,
        comment: comment,
      );
      return const Success(null);
    } on ReviewsApiException catch (e) {
      return ResultFailure(ServerFailure(e.message));
    } on DioException catch (e) {
      return ResultFailure(DioFailureMapper.map(e));
    } catch (e) {
      return ResultFailure(ExceptionMapper.map(e));
    }
  }
}
