import '../../authentication/models/user_model.dart';

abstract class ProfileService {
  Future<UserModel> getProfile();

  Future<UserModel> updateProfile({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String preferredLanguage,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
