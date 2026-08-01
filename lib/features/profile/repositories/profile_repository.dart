import '../../../core/utils/result.dart';
import '../../authentication/models/user_model.dart';

abstract class ProfileRepository {
  Future<Result<UserModel>> getProfile();

  Future<Result<UserModel>> updateProfile({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String preferredLanguage,
  });

  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
