import '../../../core/utils/result.dart';
import '../models/chalet.dart';

abstract class HomeRepository {
  Future<Result<List<Chalet>>> fetchPopularChalets();
  Future<Result<List<Chalet>>> fetchRecentlyAddedChalets();
}
