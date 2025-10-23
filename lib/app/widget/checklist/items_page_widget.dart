import 'package:flutter/material.dart';
import '../entities/shopping_item_entity.dart';
import 'check_item_widget.dart';

class ItemsPageWidget extends StatelessWidget {
  final List<ShoppingItemEntity> items;
  final Future<void> Function(ShoppingItemEntity) onToggleCompletion;
  final void Function(ShoppingItemEntity) onDeleteItem;
  final void Function(ShoppingItemEntity) onEditItem;

  const ItemsPageWidget({
    super.key,
    required this.items,
    required this.onToggleCompletion,
    required this.onDeleteItem,
    required this.onEditItem,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ChecklistItemWidget(
          item: item,
          onChanged: (value) => onToggleCompletion(item),
          onDelete: () => onDeleteItem(item),
          onEdit: () => onEditItem(item),
        );
      },
    );
  }
}
