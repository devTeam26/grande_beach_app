import 'package:dio/dio.dart';

import '../../../core/errors/failure.dart';
import '../../../core/network/dio_failure_mapper.dart';
import '../../../core/network/exception_mapper.dart';
import '../../../core/network/network_info.dart';
import '../../../core/utils/result.dart';
import '../../home/models/chalet.dart';
import '../services/chalet_details_api_exception.dart';
import '../services/chalet_details_service.dart';
import 'chalet_details_repository.dart';

class ChaletDetailsRepositoryImpl implements ChaletDetailsRepository {
  ChaletDetailsRepositoryImpl({
    required ChaletDetailsService chaletDetailsService,
    required NetworkInfo networkInfo,
  })  : _chaletDetailsService = chaletDetailsService,
        _networkInfo = networkInfo;

  final ChaletDetailsService _chaletDetailsService;
  final NetworkInfo _networkInfo;

  @override
  Future<Result<Chalet>> fetchChaletById(String id) async {
    if (!await _networkInfo.isConnected) {
      return const ResultFailure(
        NoInternetFailure(
          'No internet connection. Please check your network and try again.',
        ),
      );
    }

    try {
      final chalet = await _chaletDetailsService.fetchChaletById(id);
      return Success(chalet);
    } on ChaletDetailsApiException catch (e) {
      return ResultFailure(ServerFailure(e.message));
    } on DioException catch (e) {
      return ResultFailure(DioFailureMapper.map(e));
    } catch (e) {
      return ResultFailure(ExceptionMapper.map(e));
    }
  }
}
