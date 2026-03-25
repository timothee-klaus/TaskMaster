import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      brightness: Brightness.light,
      surface: AppColors.lightSurface,
      background: AppColors.lightBackground,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
      displayLarge: GoogleFonts.inter(
        color: AppColors.lightTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.inter(
        color: AppColors.lightTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: GoogleFonts.inter(
        color: AppColors.lightTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: GoogleFonts.inter(
        color: AppColors.lightTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: GoogleFonts.inter(
        color: AppColors.lightTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: GoogleFonts.inter(
        color: AppColors.lightTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.inter(
        color: AppColors.lightTextPrimary,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.inter(
        color: AppColors.lightTextPrimary,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: GoogleFonts.inter(
        color: AppColors.lightTextPrimary,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.inter(color: AppColors.lightTextPrimary),
      bodyMedium: GoogleFonts.inter(color: AppColors.lightTextPrimary),
      bodySmall: GoogleFonts.inter(color: AppColors.lightTextSecondary),
      labelLarge: GoogleFonts.inter(color: AppColors.lightTextPrimary),
      labelMedium: GoogleFonts.inter(color: AppColors.lightTextSecondary),
      labelSmall: GoogleFonts.inter(color: AppColors.lightTextSecondary),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.lightDivider),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      brightness: Brightness.dark,
      surface: AppColors.darkSurface,
      background: AppColors.darkBackground,
      onSurface: AppColors.darkTextPrimary,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.inter(
        color: AppColors.darkTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.inter(
        color: AppColors.darkTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: GoogleFonts.inter(
        color: AppColors.darkTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: GoogleFonts.inter(
        color: AppColors.darkTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: GoogleFonts.inter(
        color: AppColors.darkTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: GoogleFonts.inter(
        color: AppColors.darkTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.inter(
        color: AppColors.darkTextPrimary,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.inter(
        color: AppColors.darkTextPrimary,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: GoogleFonts.inter(
        color: AppColors.darkTextPrimary,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.inter(color: AppColors.darkTextPrimary),
      bodyMedium: GoogleFonts.inter(color: AppColors.darkTextPrimary),
      bodySmall: GoogleFonts.inter(color: AppColors.darkTextSecondary),
      labelLarge: GoogleFonts.inter(color: AppColors.darkTextPrimary),
      labelMedium: GoogleFonts.inter(color: AppColors.darkTextSecondary),
      labelSmall: GoogleFonts.inter(color: AppColors.darkTextSecondary),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.darkDivider),
  );
}
