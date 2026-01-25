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

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary500,
      scaffoldBackgroundColor: AppColors.neutral900,
      fontFamily: 'Poppins',
      textTheme: AppThemeData.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      colorScheme: AppThemeData.colorSchemeDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.neutral900,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
