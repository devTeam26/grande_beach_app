import 'user_model.dart';

class AuthSessionModel {
  const AuthSessionModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    this.user,
  });

  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  /// The authenticated user. Present on login/register; the refresh endpoint
  /// may omit it (only rotating the tokens), in which case the cached profile
  /// is kept as-is.
  final UserModel? user;

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return AuthSessionModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      user: user == null
          ? null
          : UserModel.fromJson(user as Map<String, dynamic>),
    );
  }
}
