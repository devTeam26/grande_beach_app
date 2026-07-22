import '../../../core/utils/result.dart';
import '../models/reviews_page.dart';

abstract class ReviewsRepository {
  Future<Result<ReviewsPage>> fetchReviews({
    required String chaletId,
    required int pageNumber,
    required int pageSize,
    int? rating,
  });

  Future<Result<void>> submitReview({
    required String bookingId,
    required int rating,
    required String comment,
  });
}
