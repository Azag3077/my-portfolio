import 'package:flutter/material.dart';

class AppColors {
  const AppColors._(this._brightness);

  final Brightness _brightness;

  static AppColors of(BuildContext context) =>
      AppColors._(Theme.of(context).brightness);

  // Accents (same for both themes)
  static const accent1 = Color(0xFFFF6B35); // Orange
  static const accent2 = Color(0xFF00D4AA); // Teal
  static const accent3 = Color(0xFF7B61FF); // Purple
  static const accent4 = Color(0xFF22C55E); // Green

  static const _accents = [accent1, accent2, accent3, accent4];

  static Color accents(int index) => _accents[index % _accents.length];

  bool get _isDark => _brightness == Brightness.dark;

  static const darkBg = Color(0xFF0A0A0F);
  static const lightBg = Color(0xFFF5F4FF);

  Color get bg => _isDark ? darkBg : lightBg;

  static const darkCard = Color(0xFF12121A);
  static const lightCard = Color(0xFFFFFFFF);

  Color get card => _isDark ? darkCard : lightCard;

  static const darkCardHover = Color(0xFF1A1A28);
  static const lightCardHover = Color(0xFFF0EEFF);

  Color get cardHover => _isDark ? darkCardHover : lightCardHover;

  static const darkBorder = Color(0xFF2A2A3A);
  static const lightBorder = Color(0xFFE0DDFF);

  Color get border => _isDark ? darkBorder : lightBorder;

  static const darkText = Color(0xFFF0EEF6);
  static const lightText = Color(0xFF0A0A1A);

  Color get text => _isDark ? darkText : lightText;

  static const darkMuted = Color(0xFF8A8A9A);
  static const lightMuted = Color(0xFF6B6B80);

  Color get muted => _isDark ? darkMuted : lightMuted;
}
