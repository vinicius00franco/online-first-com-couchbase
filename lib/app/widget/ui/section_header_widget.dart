import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../entities/view_mode_enum.dart';

class SectionHeaderWidget extends StatelessWidget {
  final ViewModeEnum viewMode;
  final int itemCount;

  const SectionHeaderWidget({
    super.key,
    required this.viewMode,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(_getIconForViewMode(viewMode),
              size: 24, color: AppColors.onPrimary),
          Text(
            '$itemCount itens',
            style:
                AppTextStyles.bodyMedium.copyWith(color: AppColors.onPrimary),
          ),
        ],
      ),
    );
  }

  IconData _getIconForViewMode(ViewModeEnum viewMode) {
    switch (viewMode) {
      case ViewModeEnum.shopping:
        return Icons.shopping_cart;
      case ViewModeEnum.purchased:
        return Icons.check;
    }
  }
}
