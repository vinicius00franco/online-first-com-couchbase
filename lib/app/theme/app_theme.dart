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

  // Novos para centralizar
  static const BorderRadius cardBorderRadius =
      BorderRadius.all(Radius.circular(16));
  static const double buttonHeight = 60.0; // Altura fixa dos botões
  static const double iconSize = 20.0; // Tamanho padrão dos ícones
  static const double separatorHeight = 1.0; // Altura das linhas separadoras
}
