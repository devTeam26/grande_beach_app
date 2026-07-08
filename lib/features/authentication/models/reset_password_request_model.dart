class ResetPasswordRequestModel {
  const ResetPasswordRequestModel({
    required this.email,
    required this.token,
    required this.newPassword,
  });

  final String email;
  final String token;
  final String newPassword;

  Map<String, dynamic> toJson() => {
        'email': email,
        'token': token,
        'newPassword': newPassword,
      };
}
