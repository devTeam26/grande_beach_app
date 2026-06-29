import '../../../core/utils/result.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Future<Result<UserModel>> login({
    required String email,
    required String password,
  });

  Future<Result<UserModel>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required String preferredLanguage,
  });

  Future<bool> hasActiveSession();
}
