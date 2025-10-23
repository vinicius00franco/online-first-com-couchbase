import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'checklist_items_widget.dart';

class SectionHeaderWidget extends StatelessWidget {
  final ViewMode viewMode;
  final int itemCount;

  const SectionHeaderWidget({
    super.key,
    required this.viewMode,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          viewMode == ViewMode.shopping ? Icons.shopping_cart : Icons.check_circle,
          color: viewMode == ViewMode.shopping ? AppColors.shoppingIcon : AppColors.purchasedIcon,
          size: 20,
        ),
        const SizedBox(width: AppSpacing.iconTextGap),
        Text(
          viewMode == ViewMode.shopping ? 'Lista de Compras ($itemCount)' : 'Comprado ($itemCount)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}