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
  static List<Color> splash = [
    const Color(0xFFFFA738).withAlpha(80),
    const Color(0xFFFFE130).withAlpha(80),
    const Color(0xFFFFE130).withAlpha(80),
    const Color(0xFFFFA738).withAlpha(80),
  ];
}
