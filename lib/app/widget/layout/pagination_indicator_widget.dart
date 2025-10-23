import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            totalPages,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: AppSpacing.iconTextGap),
              width: AppSpacing.sm,
              height: AppSpacing.sm,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentPage == index
                    ? AppColors.primary
                    : AppColors.grey400,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.sm),
          child: Text(
            'Página ${currentPage + 1} de $totalPages',
            style: AppTextStyles.caption
                .copyWith(color: AppColors.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}
