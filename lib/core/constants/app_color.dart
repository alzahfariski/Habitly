import 'package:flutter/material.dart';

class AppColors {
  // Primary Reference: 0xFF6BCF9B
  static const Color primary50 = Color(0xFFE9F7F1);
  static const Color primary100 = Color(0xFFC9EBDD);
  static const Color primary200 = Color(0xFFA8DFC9);
  static const Color primary300 = Color(0xFF87D3B5);
  static const Color primary400 = Color(0xFF6BCF9B);
  static const Color primary500 = Color(0xFF4FBF8A);
  static const Color primary600 = Color(0xFF3FA777);
  static const Color primary700 = Color(0xFF2F8F64);
  static const Color primary800 = Color(0xFF207751);
  static const Color primary900 = Color(0xFF105F3E);

  // Neutral Reference: 0xFF6B7280
  static const Color neutral50 = Color(0xFFF9FAFB);
  static const Color neutral100 = Color(0xFFF3F4F6);
  static const Color neutral200 = Color(0xFFE5E7EB);
  static const Color neutral300 = Color(0xFFD1D5DB);
  static const Color neutral400 = Color(0xFF9CA3AF);
  static const Color neutral500 = Color(0xFF6B7280);
  static const Color neutral600 = Color(0xFF4B5563);
  static const Color neutral700 = Color(0xFF374151);
  static const Color neutral800 = Color(0xFF1F2937);
  static const Color neutral900 = Color(0xFF111827);

  // Success Reference: 0xFF22C55E
  static const Color success50 = Color(0xFFEAFBF1);
  static const Color success100 = Color(0xFFCFF3DD);
  static const Color success200 = Color(0xFFB3EBC9);
  static const Color success300 = Color(0xFF97E3B5);
  static const Color success400 = Color(0xFF4ADE80);
  static const Color success500 = Color(0xFF22C55E);
  static const Color success600 = Color(0xFF16A34A);
  static const Color success700 = Color(0xFF15803D);
  static const Color success800 = Color(0xFF166534);
  static const Color success900 = Color(0xFF14532D);

  // Info Reference: 0xFF14B8A6
  static const Color info50 = Color(0xFFE6FAF7);
  static const Color info100 = Color(0xFFC2F0E9);
  static const Color info200 = Color(0xFF9EE6DB);
  static const Color info300 = Color(0xFF7ADCCD);
  static const Color info400 = Color(0xFF2DD4BF);
  static const Color info500 = Color(0xFF14B8A6);
  static const Color info600 = Color(0xFF0D9488);
  static const Color info700 = Color(0xFF0F766E);
  static const Color info800 = Color(0xFF115E59);
  static const Color info900 = Color(0xFF134E4A);

  // Warning Reference: 0xFFF59E0B
  static const Color warning50 = Color(0xFFFFF7E6);
  static const Color warning100 = Color(0xFFFFEABF);
  static const Color warning200 = Color(0xFFFFDE99);
  static const Color warning300 = Color(0xFFFFD173);
  static const Color warning400 = Color(0xFFFBBF24);
  static const Color warning500 = Color(0xFFF59E0B);
  static const Color warning600 = Color(0xFFD97706);
  static const Color warning700 = Color(0xFFB45309);
  static const Color warning800 = Color(0xFF92400E);
  static const Color warning900 = Color(0xFF78350F);

  // Danger Reference: 0xFFEF4444
  static const Color danger50 = Color(0xFFFEECEC);
  static const Color danger100 = Color(0xFFFECACA);
  static const Color danger200 = Color(0xFFFCA5A5);
  static const Color danger300 = Color(0xFFF87171);
  static const Color danger400 = Color(0xFFEF4444);
  static const Color danger500 = Color(0xFFDC2626);
  static const Color danger600 = Color(0xFFB91C1C);
  static const Color danger700 = Color(0xFF991B1B);
  static const Color danger800 = Color(0xFF7F1D1D);
  static const Color danger900 = Color(0xFF450A0A);

  // Aliases
  static const Color success = success500;
  static const Color info = info500;
  static const Color warning = warning500;
  static const Color error = danger500;

  // Background Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color background = neutral50;
  static const Color surface = white;
  static const Color scaffoldBackground = neutral100;

  // Text Colors
  static const Color textPrimary = neutral900;
  static const Color textSecondary = neutral600;
  static const Color textDisabled = neutral400;
  static const Color textInverse = white;

  // Button Colors
  static const Color buttonPrimary = primary500;
  static const Color buttonSecondary = neutral200;
  static const Color buttonDisabled = neutral300;

  // Border Colors
  static const Color border = neutral300;
  static const Color borderFocus = primary500;
  static const Color borderError = danger500;

  // Other
  static const Color divider = neutral200;
  static const Color shadow = Color(0x1F000000);
  static const Color overlay = Color(0x80000000);
}
