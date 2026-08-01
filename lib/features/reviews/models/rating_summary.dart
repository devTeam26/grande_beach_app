/// Star-rating breakdown for a chalet's reviews, computed client-side from
/// every review returned by `/api/reviews/chalet/{chaletId}` (the backend
/// exposes no dedicated summary endpoint).
class RatingSummary {
  const RatingSummary({
    required this.totalCount,
    required this.averageRating,
    required this.starCounts,
  });

  final int totalCount;
  final double averageRating;

  /// Review count per star, keyed 1 through 5.
  final Map<int, int> starCounts;

  /// Percentage (0-100) of reviews that gave [star] stars.
  double percentageFor(int star) =>
      totalCount == 0 ? 0 : (starCounts[star] ?? 0) / totalCount * 100;
}
