import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 48.0;

  static const EdgeInsets horizontal16 = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets cardPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 56);

  // Novos para centralizar
  static const EdgeInsets cardMargin =
      EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static const EdgeInsets buttonPadding =
      EdgeInsets.symmetric(vertical: 1, horizontal: md);
  static const double sectionGap = md; // Para SizedBox(height: 16)
  static const double buttonGap = sm; // Para SizedBox(width: 8)
  static const double bottomPadding = xl; // Para o espaçamento final
  static const double iconTextGap = 4.0; // Espaço entre ícone e texto
  static const double titleSeparatorGap =
      8.0; // Espaço entre título e separador
  static const double sectionTopPadding = 20.0; // Espaço no topo das seções
}
