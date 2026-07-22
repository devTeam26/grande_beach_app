import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/errors/failure.dart';
import '../../../core/network/dio_failure_mapper.dart';
import '../../../core/network/exception_mapper.dart';
import '../../../core/network/network_info.dart';
import '../../../core/utils/result.dart';
import '../models/chalet.dart';
import '../services/home_api_exception.dart';
import '../services/home_service.dart';
import 'home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({
    required HomeService homeService,
    required NetworkInfo networkInfo,
  })  : _homeService = homeService,
        _networkInfo = networkInfo;

  final HomeService _homeService;
  final NetworkInfo _networkInfo;

  @override
  Future<Result<List<Chalet>>> fetchPopularChalets() =>
      _guard('fetchPopularChalets', _homeService.fetchPopularChalets);

  @override
  Future<Result<List<Chalet>>> fetchRecentlyAddedChalets() =>
      _guard('fetchRecentlyAddedChalets', _homeService.fetchRecentlyAddedChalets);

  Future<Result<List<Chalet>>> _guard(
    String label,
    Future<List<Chalet>> Function() request,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure(
          'No internet connection. Please check your network and try again.',
        ),
      );
    }

    try {
      return Success(await request());
    } on HomeApiException catch (e) {
      debugPrint('HomeRepository.$label HomeApiException: ${e.message}');
      return ResultFailure(ServerFailure(e.message));
    } on DioException catch (e) {
      debugPrint('HomeRepository.$label DioException: ${e.message}\n${e.response?.data}');
      return ResultFailure(DioFailureMapper.map(e));
    } catch (e, stackTrace) {
      debugPrint('HomeRepository.$label error: $e\n$stackTrace');
      return ResultFailure(ExceptionMapper.map(e));
    }
  }
}
