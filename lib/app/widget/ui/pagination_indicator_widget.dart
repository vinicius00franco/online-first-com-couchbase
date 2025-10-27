import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class PaginationIndicatorWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const PaginationIndicatorWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentPage
                ? AppColors.primary
                : AppColors.outline,
          ),
        ),
      ),
    );
  }
}