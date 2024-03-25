import 'package:flutter/material.dart';

class CustomColors {
  static Color primaryColor = const Color(0xFFFFA738);
  static Color primaryTextColor = Colors.white;
  static Color secondaryTextColor = Colors.black;
  static Color dividerColor = Colors.black45;
  static Color pageBackgroundColor = const Color.fromARGB(255, 251, 250, 249);
  static List<Color> mango = [const Color(0xFFFFA738), const Color(0xFFFFE130)];
  static List<Color> mangoDim = [
    const Color(0xFFFFA738).withAlpha(80),
    const Color(0xFFFFE130).withAlpha(80)
  ];
}

class GradientColors {
  final List<Color> colors;
  GradientColors(this.colors);

  static List<Color> sky = [const Color(0xFF6448FE), const Color(0xFF5FC6FF)];
  static List<Color> sunset = [
    const Color(0xFFFE6197),
    const Color(0xFFFFB463)
  ];
  static List<Color> sea = [const Color(0xFF61A3FE), const Color(0xFF63FFD5)];
  static List<Color> mango = [const Color(0xFFFFA738), const Color(0xFFFFE130)];
  static List<Color> fire = [const Color(0xFFFF5DCD), const Color(0xFFFF8484)];
}
