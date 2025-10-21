import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData light() {
    // Use the ThemeData constructor that accepts useMaterial3 to avoid
    // the deprecated use of `useMaterial3` in copyWith.
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
      ),
      primaryColor: AppColors.primary,
      textTheme: AppTextStyles.numansTextTheme(base.textTheme),
    );
  }
}
