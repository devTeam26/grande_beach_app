import 'package:flutter/material.dart';

/// Brand color palette for GrandeBeach.
abstract class AppColors {
  static const Color primaryGold = Color(0xFFD39C00);
  static const Color primaryGrey = Color(0xFF3A3A3A);

  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Colors.white;
  static const Color lightError = Color(0xFFB00020);

  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkError = Color(0xFFCF6679);

  static const Color lightInputFill = Color(0xFFF1F1F1);
  static const Color darkInputFill = Color(0xFF2C2C2C);

  /// Warm dark gold used for the premium header across all main screens.
  static const Color headerGold = Color(0xFFA07800);

  /// Slightly deeper gold for the avatar circle inside the profile header.
  static const Color headerAvatarGold = Color(0xFF8A6510);

  // Booking status badge colors.
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusConfirmed = Color(0xFF2563EB);
  static const Color statusCheckedIn = Color(0xFF16A34A);
  static const Color statusCompleted = Color(0xFF16A34A);
  static const Color statusCancelled = Color(0xFFDC2626);

  static Color inputFill(Brightness brightness) =>
      brightness == Brightness.dark ? darkInputFill : lightInputFill;
}
