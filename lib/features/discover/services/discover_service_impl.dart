import 'package:dio/dio.dart';

import '../../../core/config/api_strings.dart';
import '../../home/models/chalet.dart';
import '../models/chalet_filters.dart';
import '../models/chalets_page.dart';
import 'discover_api_exception.dart';
import 'discover_service.dart';

class DiscoverServiceImpl implements DiscoverService {
  DiscoverServiceImpl(this._dio);

  final Dio _dio;

  @override
  Future<ChaletsPage> fetchChalets({
    required int pageNumber,
    required int pageSize,
    ChaletFilters filters = const ChaletFilters.empty(),
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiStrings.chalets,
      queryParameters: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        ...filters.toQueryParameters(),
      },
    );

    final body = response.data!;
    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw DiscoverApiException(
        body['message'] as String? ?? 'Failed to load chalets.',
      );
    }

    final data = body['data'] as Map<String, dynamic>;
    final chalets = (data['items'] as List<dynamic>)
        .map((e) => Chalet.fromJson(e as Map<String, dynamic>))
        .toList();

    return ChaletsPage(
      chalets: chalets,
      page: data['page'] as int? ?? pageNumber,
      pageSize: data['pageSize'] as int? ?? pageSize,
      totalCount: data['totalCount'] as int? ?? chalets.length,
      totalPages: data['totalPages'] as int? ?? 1,
      hasMore: data['hasNextPage'] as bool? ?? false,
    );
  }
}
