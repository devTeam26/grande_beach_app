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

  static Color inputFill(Brightness brightness) =>
      brightness == Brightness.dark ? darkInputFill : lightInputFill;
}
