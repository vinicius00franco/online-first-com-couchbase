import 'package:flutter/material.dart';
import '../entities/shopping_item_entity.dart';
import '../theme/app_text_styles.dart';

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
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        children: [
          // Total price
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.attach_money,
                color: Colors.green,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Total: R\$ ${totalPrice.toStringAsFixed(2).replaceAll('.', ',')}',
                style: AppTextStyles.sectionTitle(context).copyWith(
                  color: Colors.green.shade800,
                  fontSize: 18,
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
