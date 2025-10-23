import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  // === BASE SCALE ===
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // === SEMANTIC SPACING ===
  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets screenPadding = EdgeInsets.all(md);
  static const EdgeInsets buttonPadding =
      EdgeInsets.symmetric(vertical: sm, horizontal: md);

  // === LAYOUT SPACING ===
  static const double sectionGap = md;
  static const double itemGap = sm;
  static const double iconTextGap = xs;

  // === LEGACY SPACING (TO BE MIGRATED) ===
  static const EdgeInsets horizontal16 = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets cardMargin =
      EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static const double buttonGap = sm; // Para SizedBox(width: 8)
  static const double bottomPadding = xl; // Para o espaçamento final
  static const double titleSeparatorGap = sm; // Espaço entre título e separador
  static const double sectionTopPadding = 20.0; // Espaço no topo das seções
}
