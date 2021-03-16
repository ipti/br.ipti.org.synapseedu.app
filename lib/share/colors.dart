import 'dart:ui';

import 'package:flutter/material.dart';

enum LecoColors {
  blue040,
}

extension LecoColorsExtension on LecoColors {
  Color get color {
    switch (this) {
      case LecoColors.blue040:
        return Color.fromRGBO(0, 0, 255, 0.4);
      default:
        return Colors.red;
    }
  }
}
