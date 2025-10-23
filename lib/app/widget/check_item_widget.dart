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
    print(
        'ChecklistItemWidget: Construindo item ${widget.item.id} - ${widget.item.title} - Preço: ${widget.item.price}');
    return ExpansionTile(
      leading: Checkbox(
        activeColor: AppColors.black,
        value: widget.item.isCompleted,
        onChanged: widget.onChanged,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              widget.item.title,
              style: TextStyle(
                decoration: widget.item.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.black,
                ),
                onPressed: widget.onEdit,
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: AppColors.black,
                ),
                onPressed: widget.onDelete,
              ),
            ],
          ),
        ],
      ),
      subtitle: Text(
        'Toque para ver detalhes',
        style: AppTextStyles.subtitle.copyWith(fontSize: 12),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.attach_money, color: Colors.green, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Preço: R\$ ${widget.item.price.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: AppTextStyles.subtitle.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '📅 Criado em: ${DateFormat('EEEE (dd/MM/yyyy) - HH:mm', 'pt_BR').format(widget.item.createdAt)}',
                style: AppTextStyles.subtitle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
