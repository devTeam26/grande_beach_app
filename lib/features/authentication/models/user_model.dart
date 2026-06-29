class UserModel {
  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.preferredLanguage,
    required this.loyaltyPoints,
    required this.totalBookings,
    required this.roles,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String preferredLanguage;
  final int loyaltyPoints;
  final int totalBookings;
  final List<String> roles;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      preferredLanguage: json['preferredLanguage'] as String,
      loyaltyPoints: json['loyaltyPoints'] as int,
      totalBookings: json['totalBookings'] as int,
      roles: (json['roles'] as List).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'preferredLanguage': preferredLanguage,
        'loyaltyPoints': loyaltyPoints,
        'totalBookings': totalBookings,
        'roles': roles,
      };
}
