import 'package:flutter/material.dart';
import 'package:flutter_scan/themes/colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    primaryColor: primary,
    primaryColorDark: primaryDark,
    primaryColorLight: primaryLight,
    hoverColor: divider,
    hintColor: primaryDark,
    colorScheme: const ColorScheme.light(primary: primary)
  );
}