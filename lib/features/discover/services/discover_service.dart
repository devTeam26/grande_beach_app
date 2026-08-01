import '../models/chalet_filters.dart';
import '../models/chalets_page.dart';

abstract class DiscoverService {
  Future<ChaletsPage> fetchChalets({
    required int pageNumber,
    required int pageSize,
    ChaletFilters filters = const ChaletFilters.empty(),
  });
}
