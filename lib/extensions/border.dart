import 'package:flutter/material.dart';

extension BorderExtension on Border {
  Border copyWith({
    BorderSide? top,
    BorderSide? left,
    BorderSide? right,
    BorderSide? bottom,
  }) {
    return Border(
      top: top ?? this.top,
      left: left ?? this.left,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
    );
  }
}
