/// Base URL and endpoint paths for the GrandeBeach API.
abstract class ApiStrings {
  static const String baseUrl = 'https://api.grandebeach.com';

  // Auth
  static const String login = '/api/Auth/login';
  static const String register = '/api/Auth/register';
  static const String resetPassword = '/api/Auth/reset-password';
  static const String logout = '/api/Auth/logout';
  static const String profile = '/api/Auth/profile';
  static const String changePassword = '/api/Auth/change-password';

  // Chalets
  static const String chalets = '/api/Chalets';
  static String chaletById(String id) => '$chalets/$id';

  // Bookings
  static const String bookings = '/api/Bookings';
  static const String myBookings = '/api/Bookings/my';
  static String bookingById(String id) => '$bookings/$id';
  static String cancelBooking(String id) => '$bookings/$id/cancel';
}
