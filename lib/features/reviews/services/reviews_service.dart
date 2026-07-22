import '../models/reviews_page.dart';

abstract class ReviewsService {
  Future<ReviewsPage> fetchReviews({
    required String chaletId,
    required int pageNumber,
    required int pageSize,
    int? rating,
  });

  Future<void> submitReview({
    required String bookingId,
    required int rating,
    required String comment,
  });
}
