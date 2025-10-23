import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // === HEADINGS ===
  static const TextStyle h1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.onSurface,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );

  // === BODY TEXT ===
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
  );

  // === COMPONENT SPECIFIC ===
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.onPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
  );

  // === LEGACY STYLES (TO BE MIGRATED) ===
  static TextStyle sectionTitle(BuildContext context) => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      );

  static const TextStyle subtitle = TextStyle(fontSize: 12);
  static const TextStyle hint = TextStyle(color: AppColors.hint);

  static const TextStyle footer = TextStyle(
    fontSize: 12,
    color: AppColors.onSurfaceVariant,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle itemTitle = TextStyle(
    fontSize: 16,
    color: AppColors.onSurface,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle sectionTitleConst = TextStyle(
    fontSize: 18,
    color: AppColors.onSurface,
    fontWeight: FontWeight.w600,
  );

  static TextTheme numansTextTheme(TextTheme base) =>
      GoogleFonts.numansTextTheme(base);
}
