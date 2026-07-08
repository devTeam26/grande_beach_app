import '../../../core/utils/result.dart';
import '../../home/models/chalet.dart';

abstract class ChaletDetailsRepository {
  Future<Result<Chalet>> fetchChaletById(String id);
}
