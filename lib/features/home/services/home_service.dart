import '../models/chalet.dart';

abstract class HomeService {
  /// Chalets for the home "Popular" section — /api/Chalets/popular.
  Future<List<Chalet>> fetchPopularChalets();

  /// Chalets for the home "Recently Added" section — /api/Chalets/recently-added.
  Future<List<Chalet>> fetchRecentlyAddedChalets();
}
