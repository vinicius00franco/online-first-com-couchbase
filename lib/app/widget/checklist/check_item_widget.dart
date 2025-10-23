import 'package:checklist/app/entities/shopping_item_entity.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import '../utils/logger.dart' as app_logger;
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
    app_logger.Logger.instance.info(
        'ChecklistItemWidget: Construindo item ${widget.item.id} - ${widget.item.title} - Preço: ${widget.item.price}');
    return ExpansionTile(
      leading: Checkbox(
        activeColor: AppColors.onSurface,
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
                  color: AppColors.onSurface,
                ),
                onPressed: widget.onEdit,
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: AppColors.onSurface,
                ),
                onPressed: widget.onDelete,
              ),
            ],
          ),
        ],
      ),
      subtitle: Text(
        'Toque para ver detalhes',
        style: AppTextStyles.bodySmall,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.attach_money,
                      color: AppColors.priceIcon, size: AppTheme.iconSize),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Preço: R\$ ${widget.item.price.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: AppTextStyles.subtitle.copyWith(
                      color: AppColors.priceText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
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
