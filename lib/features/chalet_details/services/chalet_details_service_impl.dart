import 'package:dio/dio.dart';

import '../../../core/config/api_strings.dart';
import '../../home/models/chalet.dart';
import 'chalet_details_api_exception.dart';
import 'chalet_details_service.dart';

class ChaletDetailsServiceImpl implements ChaletDetailsService {
  ChaletDetailsServiceImpl(this._dio);

  final Dio _dio;

  @override
  Future<Chalet> fetchChaletById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiStrings.chaletById(id),
    );

    final body = response.data!;
    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw ChaletDetailsApiException(
        body['message'] as String? ?? 'Failed to load chalet.',
      );
    }

    return Chalet.fromJson(body['data'] as Map<String, dynamic>);
  }
}
