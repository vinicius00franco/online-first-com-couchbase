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

  static TextTheme numansTextTheme(TextTheme base) =>
      GoogleFonts.numansTextTheme(base);
}
