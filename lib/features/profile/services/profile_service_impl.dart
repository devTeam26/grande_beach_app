import 'package:dio/dio.dart';

import '../../../core/config/api_strings.dart';
import '../../authentication/models/user_model.dart';
import '../../authentication/services/auth_api_exception.dart';
import '../models/change_password_request_model.dart';
import '../models/update_profile_request_model.dart';
import 'profile_service.dart';

class ProfileServiceImpl implements ProfileService {
  ProfileServiceImpl(this._dio);

  final Dio _dio;

  @override
  Future<UserModel> getProfile() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiStrings.profile);
    final body = response.data!;
    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw AuthApiException(
        body['message'] as String? ?? 'Failed to fetch profile.',
      );
    }
    return UserModel.fromJson(body['data'] as Map<String, dynamic>);
  }

  @override
  Future<UserModel> updateProfile({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String preferredLanguage,
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiStrings.profile,
      data: UpdateProfileRequestModel(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        preferredLanguage: preferredLanguage,
      ).toJson(),
    );
    final body = response.data!;
    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw AuthApiException(
        body['message'] as String? ?? 'Failed to update profile.',
      );
    }
    return UserModel.fromJson(body['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiStrings.changePassword,
      data: ChangePasswordRequestModel(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ).toJson(),
    );
    final body = response.data!;
    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw AuthApiException(
        body['message'] as String? ?? 'Failed to change password.',
      );
    }
  }
}
