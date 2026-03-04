import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../extensions/extensions.dart';
import 'colors.dart';

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

  static TextTheme _textTheme(Color color, Color muted) => Typography
      .englishLike2018
      .apply(fontSizeFactor: 1.0.sp)
      .copyWith(
        displayLarge: GoogleFonts.syne(
          fontSize: 88.0.sp,
          fontWeight: .w800,
          color: color,
          letterSpacing: -3,
        ),
        displayMedium: GoogleFonts.syne(
          fontSize: 56.0.sp,
          fontWeight: .w800,
          color: color,
          letterSpacing: -2,
        ),
        displaySmall: GoogleFonts.syne(
          fontSize: 40.0.sp,
          fontWeight: .w800,
          color: color,
          letterSpacing: -1,
        ),
        headlineMedium: GoogleFonts.syne(
          fontSize: 26.0.sp,
          fontWeight: .w800,
          color: color,
        ),
        headlineSmall: GoogleFonts.syne(
          fontSize: 22.0.sp,
          fontWeight: .w700,
          color: color,
        ),
        titleLarge: GoogleFonts.dmSans(
          fontSize: 18.0.sp,
          fontWeight: .w700,
          color: color,
        ),
        titleMedium: GoogleFonts.dmSans(
          fontSize: 15.0.sp,
          fontWeight: .w600,
          color: color,
        ),
        bodyLarge: GoogleFonts.dmSans(
          fontSize: 16.0.sp,
          fontWeight: .w400,
          color: muted,
          height: 1.75,
        ),
        bodyMedium: GoogleFonts.dmSans(
          fontSize: 14.0.sp,
          fontWeight: .w400,
          color: muted,
          height: 1.7,
        ),
        labelLarge: GoogleFonts.dmSans(
          fontSize: 13.0.sp,
          fontWeight: .w700,
          color: muted,
          letterSpacing: 2,
        ),
        labelMedium: GoogleFonts.dmSans(
          fontSize: 12.0.sp,
          fontWeight: .w600,
          color: muted,
        ),
      );
}
