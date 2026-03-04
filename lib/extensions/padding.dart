import 'package:flutter/material.dart';

extension EdgeInsetsExtension on EdgeInsets {
  EdgeInsets allBut({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    copyWith();
    return EdgeInsets.only(
      left: left ?? this.left,
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
    );
  }
}

extension NeutralizeScreenUtil on num {
  // static const _tabletRatio = 0.888;
  // static const _mobileRatio = 0.777;
  static const _mobileRatio = 1;

  double get sp => toDouble() * _mobileRatio;

  double get w => toDouble() * _mobileRatio;

  double get h => toDouble() * _mobileRatio;

  double get r => toDouble() * _mobileRatio;

  double sw(BuildContext context) =>
      MediaQuery.of(context).size.width * toDouble();

  // double get sh => toDouble();

  SizedBox get horizontalSpace => SizedBox(width: toDouble() * _mobileRatio);

  SizedBox get verticalSpace => SizedBox(height: toDouble() * _mobileRatio);
}

class RS {
  static const _tabletRatio = 0.888;
  static const _mobileRatio = 0.777;

  static double size(BuildContext context, double desktop) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024) return desktop;
    if (width >= 600) return desktop * _tabletRatio;
    return desktop * _mobileRatio;
  }
}
