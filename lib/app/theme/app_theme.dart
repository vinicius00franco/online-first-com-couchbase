import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        outline: AppColors.outline,
      ),
      textTheme: AppTextStyles.numansTextTheme(base.textTheme),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(cardRadius)),
        ),
      ),
    );
  }

  // === DESIGN TOKENS ===
  static const double borderRadius = 8.0;
  static const double cardRadius = 12.0;
  static const double buttonHeight = 48.0;
  static const double iconSize = 24.0;

  // === LEGACY TOKENS (TO BE MIGRATED) ===
  static const BorderRadius cardBorderRadius =
      BorderRadius.all(Radius.circular(16));
  static const double separatorHeight = 1.0; // Altura das linhas separadoras
}
