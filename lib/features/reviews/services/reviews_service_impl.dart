import 'package:dio/dio.dart';

import '../../../core/config/api_strings.dart';
import '../models/review.dart';
import '../models/reviews_page.dart';
import 'reviews_api_exception.dart';
import 'reviews_service.dart';

class ReviewsServiceImpl implements ReviewsService {
  ReviewsServiceImpl(this._dio);

  final Dio _dio;

  @override
  Future<ReviewsPage> fetchReviews({
    required String chaletId,
    required int pageNumber,
    required int pageSize,
    int? rating,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiStrings.reviewsByChalet(chaletId),
      queryParameters: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        'rating': ?rating,
      },
    );

    final body = response.data!;
    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw ReviewsApiException(
        body['message'] as String? ?? 'Failed to load reviews.',
      );
    }

    final data = body['data'] as Map<String, dynamic>;
    final reviewsJson = data['reviews'] as Map<String, dynamic>;
    final reviews = (reviewsJson['items'] as List<dynamic>)
        .map((e) => Review.fromJson(e as Map<String, dynamic>))
        .toList();

    return ReviewsPage(
      reviews: reviews,
      page: reviewsJson['page'] as int? ?? pageNumber,
      pageSize: reviewsJson['pageSize'] as int? ?? pageSize,
      totalCount: reviewsJson['totalCount'] as int? ?? reviews.length,
      totalPages: reviewsJson['totalPages'] as int? ?? 1,
      hasMore: reviewsJson['hasNextPage'] as bool? ?? false,
    );
  }

  @override
  Future<void> submitReview({
    required String bookingId,
    required int rating,
    required String comment,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiStrings.reviews,
      data: {
        'bookingId': bookingId,
        'rating': rating,
        'comment': comment,
      },
    );

    final body = response.data!;
    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw ReviewsApiException(
        body['message'] as String? ?? 'Failed to submit review.',
      );
    }
  }
}
