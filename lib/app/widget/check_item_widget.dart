import 'package:checklist/app/entities/shopping_item_entity.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'package:intl/intl.dart';

class ChecklistItemWidget extends StatefulWidget {
  final ShoppingItemEntity item;
  final Function(bool?) onChanged;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ChecklistItemWidget({
    super.key,
    required this.item,
    required this.onChanged,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<ChecklistItemWidget> createState() => _ChecklistItemWidgetState();
}

class _ChecklistItemWidgetState extends State<ChecklistItemWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        activeColor: AppColors.black,
        value: widget.item.isCompleted,
        onChanged: widget.onChanged,
      ),
      title: Text(
        widget.item.title,
        style: TextStyle(
          decoration: widget.item.isCompleted
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),
      subtitle: Text(
        DateFormat('EEEE (dd/MM/yyyy) - HH:mm').format(widget.item.createdAt),
        style: AppTextStyles.subtitle,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: AppColors.black,
            ),
            onPressed: widget.onDelete,
          ),
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: AppColors.black,
            ),
            onPressed: widget.onEdit,
          ),
        ],
      ),
    );
  }
}
