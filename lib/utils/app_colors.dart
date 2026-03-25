import 'package:flutter/material.dart';

class AppColors {
  // --- Core Colors ---
  static const Color primary = Color(0xFFFF5A4A); // Coral / Red
  static const Color secondary = Color(0xFF4285F4); // Google Blue

  // --- Light Theme ---
  static const Color lightBackground = Color(0xFFF8F9FC);
  static const Color lightSurface = Colors.white;
  static const Color lightTextPrimary = Color(0xFF101828);
  static const Color lightTextSecondary = Color(0xFF667085);
  static const Color lightTextTertiary = Color(0xFF475467);
  static const Color lightBorder = Color(0xFFEAECF0);
  static const Color lightDivider = Color(0xFFF2F4F7);

  // --- Dark Theme ---
  static const Color darkBackground = Color(0xFF0C111D);
  static const Color darkSurface = Color(0xFF1D2939);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF98A2B3);
  static const Color darkTextTertiary = Color(0xFF667085);
  static const Color darkBorder = Color(0xFF344054);
  static const Color darkDivider = Color(0xFF344054);

  // --- Semantic Colors ---
  static const Color success = Color(0xFF12B76A);
  static const Color warning = Color(0xFFF79009);
  static const Color error = Color(0xFFD92D20);
  static const Color info = Color(0xFF2E90FA);

  // --- Functional Helpers ---
  static Color getBackground(bool isDark) =>
      isDark ? darkBackground : lightBackground;
  static Color getSurface(bool isDark) => isDark ? darkSurface : lightSurface;
  static Color getTextPrimary(bool isDark) =>
      isDark ? darkTextPrimary : lightTextPrimary;
  static Color getTextSecondary(bool isDark) =>
      isDark ? darkTextSecondary : lightTextSecondary;
  static Color getBorder(bool isDark) => isDark ? darkBorder : lightBorder;
}
