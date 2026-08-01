import '../../../core/utils/result.dart';
import '../models/chalet_filters.dart';
import '../models/chalets_page.dart';

abstract class DiscoverRepository {
  Future<Result<ChaletsPage>> fetchChalets({
    required int pageNumber,
    required int pageSize,
    ChaletFilters filters = const ChaletFilters.empty(),
  });
}
