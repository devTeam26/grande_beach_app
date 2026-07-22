import 'review.dart';

/// A single page of the /api/reviews/chalet/{chaletId} paginated response.
class ReviewsPage {
  const ReviewsPage({
    required this.reviews,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasMore,
  });

  final List<Review> reviews;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasMore;
}
