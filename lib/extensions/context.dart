import 'package:flutter/material.dart';

import '../constants/constants.dart';

extension ScreenSizeExtension on BuildContext {
  double get _wid => MediaQuery.of(this).size.width;

  bool get isMobile => _wid < BreakPoint.mobile;

  bool get isDesktop => _wid >= BreakPoint.desktop;

  bool get isTablet => _wid >= BreakPoint.mobile && _wid < BreakPoint.desktop;
}

extension ThemeBrightnessExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
