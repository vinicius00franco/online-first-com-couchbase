import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle sectionTitle(BuildContext context) => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      );

  static const TextStyle button =
      TextStyle(color: AppColors.white, fontSize: 18);
  static const TextStyle subtitle = TextStyle(fontSize: 12);
  static const TextStyle hint = TextStyle(color: AppColors.hint);

  // Novos para centralizar
  static const TextStyle footer = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle itemTitle = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle sectionTitleConst = TextStyle(
    fontSize: 18,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w600,
  );

  static TextTheme numansTextTheme(TextTheme base) =>
      GoogleFonts.numansTextTheme(base);
}
