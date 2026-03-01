import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Accents - same in both modes
  static const accent1 = Color(0xFFFF6B35); // Orange
  static const accent2 = Color(0xFF00D4AA); // Teal
  static const accent3 = Color(0xFF7B61FF); // Purple

  // Dark mode
  static const darkBg = Color(0xFF0A0A0F);
  static const darkCard = Color(0xFF12121A);
  static const darkCardHover = Color(0xFF1A1A28);
  static const darkBorder = Color(0xFF2A2A3A);
  static const darkText = Color(0xFFF0EEF6);
  static const darkMuted = Color(0xFF8A8A9A);

  // Light mode
  static const lightBg = Color(0xFFF5F4FF);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightCardHover = Color(0xFFF0EEFF);
  static const lightBorder = Color(0xFFE0DDFF);
  static const lightText = Color(0xFF0A0A1A);
  static const lightMuted = Color(0xFF6B6B80);
}

class AppTheme {
  static ThemeData dark() => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent1,
      secondary: AppColors.accent2,
      tertiary: AppColors.accent3,
      surface: AppColors.darkCard,
    ),
    textTheme: _textTheme(AppColors.darkText, AppColors.darkMuted),
    useMaterial3: true,
  );

  static ThemeData light() => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBg,
    colorScheme: const ColorScheme.light(
      primary: AppColors.accent1,
      secondary: AppColors.accent2,
      tertiary: AppColors.accent3,
      surface: AppColors.lightCard,
    ),
    textTheme: _textTheme(AppColors.lightText, AppColors.lightMuted),
    useMaterial3: true,
  );

  static TextTheme _textTheme(Color text, Color muted) => TextTheme(
    displayLarge: GoogleFonts.syne(
      fontSize: 88,
      fontWeight: FontWeight.w800,
      color: text,
      letterSpacing: -3,
    ),
    displayMedium: GoogleFonts.syne(
      fontSize: 56,
      fontWeight: FontWeight.w800,
      color: text,
      letterSpacing: -2,
    ),
    displaySmall: GoogleFonts.syne(
      fontSize: 40,
      fontWeight: FontWeight.w800,
      color: text,
      letterSpacing: -1,
    ),
    headlineMedium: GoogleFonts.syne(
      fontSize: 26,
      fontWeight: FontWeight.w800,
      color: text,
    ),
    headlineSmall: GoogleFonts.syne(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: text,
    ),
    titleLarge: GoogleFonts.dmSans(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: text,
    ),
    titleMedium: GoogleFonts.dmSans(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: text,
    ),
    bodyLarge: GoogleFonts.dmSans(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: muted,
      height: 1.75,
    ),
    bodyMedium: GoogleFonts.dmSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: muted,
      height: 1.7,
    ),
    labelLarge: GoogleFonts.dmSans(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: muted,
      letterSpacing: 2,
    ),
    labelMedium: GoogleFonts.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: muted,
    ),
  );
}
