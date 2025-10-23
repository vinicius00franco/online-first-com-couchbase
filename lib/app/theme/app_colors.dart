import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // === BRAND COLORS ===
  static const Color primary = Color(0xFFF55B64);
  static const Color gradientStart = Color(0xFF020307);
  static const Color gradientEnd = Color(0xFF232F76);

  // === NEUTRAL COLORS ===
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey800 = Color(0xFF424242);

  // === SEMANTIC COLORS ===
  static const Color success = Colors.green;
  static const Color info = Colors.blue;
  static const Color warning = Colors.orange;
  static const Color error = Colors.red;

  // === SURFACE COLORS ===
  static const Color surface = white;
  static const Color surfaceVariant = grey100;
  static const Color outline = grey300;

  // === CONTENT COLORS ===
  static const Color onSurface = black;
  static const Color onSurfaceVariant = grey600;
  static const Color onPrimary = white;

  // === COMPONENT SPECIFIC ===
  static const Color buttonInactive = grey300;
  static const Color hint = Color(0xFF8A8A8A);

  // === LEGACY COLORS (TO BE MIGRATED) ===
  static const Color cardBackground = white; // Use surface instead
  static const Color buttonActiveText = white; // Use onPrimary instead
  static const Color buttonInactiveText = black; // Use onSurface instead
  static const Color footerText = white; // Use onPrimary instead
  static const Color shoppingIcon = Colors.blue; // Use info instead
  static const Color purchasedIcon = Colors.green; // Use success instead
  static const Color separator = grey300; // Use outline instead
  static const Color textPrimary = black; // Use onSurface instead
  static const Color textSecondary = grey600; // Use onSurfaceVariant instead
  static const Color priceIcon = Colors.green; // Use success instead
  static const Color priceText = Color(0xFF2E7D32); // Custom semantic color
  static const Color totalBackground =
      Color(0xFFE8F5E8); // Custom surface variant
  static const Color totalBorder = Color(0xFF81C784); // Custom outline
  static const Color totalText = Color(0xFF1B5E20); // Custom onSurface variant
  static const Color sectionSeparator = grey300; // Use outline instead
}
