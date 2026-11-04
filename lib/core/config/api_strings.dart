/// Base URL and endpoint paths for the GrandeBeach API.
abstract class ApiStrings {
  static const String baseUrl = 'https://api.grandebeach.com';

  // Auth
  static const String login = '/api/Auth/login';
  static const String register = '/api/Auth/register';
  static const String refresh = '/api/Auth/refresh';
  static const String resetPassword = '/api/Auth/reset-password';
  static const String forgotPassword = '/api/Auth/forgot-password';
  static const String googleLogin = '/api/Auth/google-login';
  static const String logout = '/api/Auth/logout';
  static const String account = '/api/Auth/account';
  static const String profile = '/api/Auth/profile';
  static const String changePassword = '/api/Auth/change-password';

  // Chalets
  static const String chalets = '/api/Chalets';
  static const String popularChalets = '/api/Chalets/popular';
  static const String recentlyAddedChalets = '/api/Chalets/recently-added';
  static String chaletById(String id) => '$chalets/$id';
  static String chaletAvailability(String id) => '$chalets/$id/availability';

  // Bookings
  static const String bookings = '/api/Bookings';
  static const String myBookings = '/api/Bookings/my';
  static String bookingById(String id) => '$bookings/$id';
  static String cancelBooking(String id) => '$bookings/$id/cancel';
  static const String pricePreview = '/api/Bookings/price-preview';

  // Add-ons
  static const String addOns = '/api/AddOns';

  // Verification
  static const String verification = '/api/Verification';
  static const String myVerification = '/api/Verification/my';

  // Reviews
  static const String reviews = '/api/reviews';
  static String reviewsByChalet(String chaletId) =>
      '/api/reviews/chalet/$chaletId';
}
