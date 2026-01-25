import 'package:flutter/material.dart';
import '../constants/app_color.dart';
import 'app_theme_data.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary500,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Poppins',
      textTheme: AppThemeData.textTheme,
      colorScheme: AppThemeData.colorSchemeLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary500,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
