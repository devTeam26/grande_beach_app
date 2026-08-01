class UpdateProfileRequestModel {
  const UpdateProfileRequestModel({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.preferredLanguage,
  });

  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String preferredLanguage;

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'preferredLanguage': preferredLanguage,
      };
}
