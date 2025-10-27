import 'package:flutter/material.dart';
import '../../entities/shopping_item_entity.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_theme.dart';

class TotalWidget extends StatelessWidget {
  final List<ShoppingItemEntity> items;

  const TotalWidget({
    super.key,
    required this.items,
  });

  double get totalPrice {
    return items.fold(0.0, (sum, item) => sum + item.price);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.totalBackground,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: AppColors.totalBorder),
      ),
      child: Column(
        children: [
          // Total price
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.attach_money,
                color: AppColors.priceIcon,
                size: AppTheme.iconSize,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Total: R\$ ${totalPrice.toStringAsFixed(2).replaceAll('.', ',')}',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.totalText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
