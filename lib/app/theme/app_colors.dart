import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFF55B64);
  static const Color gradientStart = Color(0xFF020307);
  static const Color gradientEnd = Color(0xFF232F76);
  static const Color hint = Color(0xFF8A8A8A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Novos para centralizar
  static const Color cardBackground = Colors.white; // Para containers
  static const Color buttonInactive =
      Color(0xFFE0E0E0); // Substitui Colors.grey.shade300
  static const Color buttonActiveText =
      Colors.white; // Para texto de botões ativos
  static const Color buttonInactiveText =
      Colors.black; // Para texto de botões inativos
  static const Color footerText = Colors.white; // Para texto do footer
  static const Color shoppingIcon =
      Colors.blue; // Para ícone de lista de compras
  static const Color purchasedIcon = Colors.green; // Para ícone de check
  static const Color separator = Color(0xFFE0E0E0); // Para linhas separadoras
  static const Color textPrimary = Colors.black; // Para texto principal
  static const Color textSecondary = Color(0xFF666666); // Para texto secundário
  static const Color priceIcon = Colors.green; // Para ícone de preço
  static const Color priceText =
      Color(0xFF2E7D32); // Para texto de preço (verde escuro)
  static const Color totalBackground =
      Color(0xFFE8F5E8); // Para fundo do total (verde claro)
  static const Color totalBorder = Color(0xFF81C784); // Para borda do total
  static const Color totalText = Color(0xFF1B5E20); // Para texto do total
  static const Color sectionSeparator =
      Color(0xFFE0E0E0); // Para separadores de seção
}
