import 'package:flutter/material.dart';
import '../entities/shopping_item_entity.dart';
import 'check_item_widget.dart';

class ItemsListWidget extends StatelessWidget {
  final List<ShoppingItemEntity> items;
  final Future<void> Function(ShoppingItemEntity) onToggleCompletion;
  final void Function(ShoppingItemEntity) onDeleteItem;
  final void Function(ShoppingItemEntity) onEditItem;

  const ItemsListWidget({
    super.key,
    required this.items,
    required this.onToggleCompletion,
    required this.onDeleteItem,
    required this.onEditItem,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ChecklistItemWidget(
          item: items[index],
          onChanged: (value) => onToggleCompletion(items[index]),
          onDelete: () => onDeleteItem(items[index]),
          onEdit: () => onEditItem(items[index]),
        );
      },
    );
  }
}
