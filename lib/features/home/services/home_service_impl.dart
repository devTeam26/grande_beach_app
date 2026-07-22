import 'package:dio/dio.dart';

import '../../../core/config/api_strings.dart';
import '../models/chalet.dart';
import 'home_api_exception.dart';
import 'home_service.dart';

class HomeServiceImpl implements HomeService {
  HomeServiceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<Chalet>> fetchPopularChalets() =>
      _fetchChalets(ApiStrings.popularChalets);

  @override
  Future<List<Chalet>> fetchRecentlyAddedChalets() =>
      _fetchChalets(ApiStrings.recentlyAddedChalets);

  Future<List<Chalet>> _fetchChalets(String path) async {
    final response = await _dio.get<Map<String, dynamic>>(path);

    final body = response.data!;
    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw HomeApiException(
        body['message'] as String? ?? 'Failed to load chalets.',
      );
    }

    return _parseChalets(body['data']);
  }

  /// These endpoints return chalets like /api/Chalets, so `data` may be either
  /// a bare list or the paginated `{ items: [...] }` envelope.
  List<Chalet> _parseChalets(Object? data) {
    final List<dynamic> items;
    if (data is List) {
      items = data;
    } else if (data is Map<String, dynamic> && data['items'] is List) {
      items = data['items'] as List<dynamic>;
    } else {
      items = const [];
    }

    return items
        .map((e) => Chalet.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
