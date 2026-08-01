import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/errors/failure.dart';
import '../../../core/network/dio_failure_mapper.dart';
import '../../../core/network/exception_mapper.dart';
import '../../../core/network/network_info.dart';
import '../../../core/utils/result.dart';
import '../models/chalet_filters.dart';
import '../models/chalets_page.dart';
import '../services/discover_api_exception.dart';
import '../services/discover_service.dart';
import 'discover_repository.dart';

class DiscoverRepositoryImpl implements DiscoverRepository {
  DiscoverRepositoryImpl({
    required DiscoverService discoverService,
    required NetworkInfo networkInfo,
  })  : _discoverService = discoverService,
        _networkInfo = networkInfo;

  final DiscoverService _discoverService;
  final NetworkInfo _networkInfo;

  @override
  Future<Result<ChaletsPage>> fetchChalets({
    required int pageNumber,
    required int pageSize,
    ChaletFilters filters = const ChaletFilters.empty(),
  }) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure(
          'No internet connection. Please check your network and try again.',
        ),
      );
    }

    try {
      final page = await _discoverService.fetchChalets(
        pageNumber: pageNumber,
        pageSize: pageSize,
        filters: filters,
      );
      return Success(page);
    } on DiscoverApiException catch (e) {
      debugPrint('DiscoverRepository.fetchChalets DiscoverApiException: ${e.message}');
      return ResultFailure(ServerFailure(e.message));
    } on DioException catch (e) {
      debugPrint('DiscoverRepository.fetchChalets DioException: ${e.message}\n${e.response?.data}');
      return ResultFailure(DioFailureMapper.map(e));
    } catch (e, stackTrace) {
      debugPrint('DiscoverRepository.fetchChalets error: $e\n$stackTrace');
      return ResultFailure(ExceptionMapper.map(e));
    }
  }
}
