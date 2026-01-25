import 'package:flutter/material.dart';
import '../constants/app_color.dart';
import 'app_text_style.dart';

class AppThemeData {
  static const ColorScheme colorSchemeLight = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary500,
    onPrimary: Colors.white,
    secondary: AppColors.primary500,
    onSecondary: Colors.white,
    error: AppColors.danger500,
    onError: Colors.white,
    surface: AppColors.surface,
    onSurface: AppColors.black,
  );

  static const ColorScheme colorSchemeDark = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary500,
    onPrimary: Colors.white,
    secondary: AppColors.primary500,
    onSecondary: Colors.white,
    error: AppColors.danger500,
    onError: Colors.white,
    surface: AppColors.neutral900,
    onSurface: Colors.white,
  );

  static const TextTheme textTheme = TextTheme(
    displayLarge: AppTextStyles.displayLarge,
    displayMedium: AppTextStyles.displayMedium,
    displaySmall: AppTextStyles.displaySmall,
    headlineLarge: AppTextStyles.headlineLarge,
    headlineMedium: AppTextStyles.headlineMedium,
    headlineSmall: AppTextStyles.headlineSmall,
    titleLarge: AppTextStyles.titleLarge,
    titleMedium: AppTextStyles.titleMedium,
    titleSmall: AppTextStyles.titleSmall,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodyMedium,
    bodySmall: AppTextStyles.bodySmall,
    labelLarge: AppTextStyles.labelLarge,
    labelMedium: AppTextStyles.labelMedium,
    labelSmall: AppTextStyles.labelSmall,
  );
}
