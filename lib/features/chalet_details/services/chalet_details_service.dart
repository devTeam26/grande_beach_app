import '../../home/models/chalet.dart';

abstract class ChaletDetailsService {
  Future<Chalet> fetchChaletById(String id);
}
