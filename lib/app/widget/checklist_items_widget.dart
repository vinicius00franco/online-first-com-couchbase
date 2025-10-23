// ignore_for_file: use_build_context_synchronously

import 'package:checklist/app/logic/checklist/checklist_cubit.dart';
import 'package:checklist/app/pages/checklist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../entities/shopping_item_entity.dart';
import '../logic/checklist/checklist_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../utils/logger.dart' as app_logger;
import 'check_item_widget.dart';

class ChecklistItemsBuilder extends StatelessWidget {
  final ViewMode viewMode; // Adicionar
  final Future<void> Function(ShoppingItemEntity) onToggleCompletion;
  final void Function(ShoppingItemEntity) onDeleteItem;
  final void Function(ShoppingItemEntity) onEditItem;

  const ChecklistItemsBuilder({
    super.key,
    required this.viewMode, // Adicionar
    required this.onToggleCompletion,
    required this.onDeleteItem,
    required this.onEditItem,
  });

  @override
  Widget build(BuildContext context) {
    app_logger.Logger.instance.info('ChecklistItemsBuilder: Reconstruindo widget');
    return BlocBuilder<FetchChecklistCubit, FetchChecklistState>(
      builder: (context, state) {
        app_logger.Logger.instance.info('ChecklistItemsBuilder: Estado recebido: $state');
        if (state is FetchChecklistLoading) {
          return const CircularProgressIndicator();
        } else if (state is FetchChecklistLoaded) {
          final items = viewMode == ViewMode.shopping
              ? state.items.where((item) => !item.isCompleted).toList()
              : state.items.where((item) => item.isCompleted).toList();

          app_logger.Logger.instance.info(
              'ChecklistItemsBuilder: ${items.length} itens carregados para modo $viewMode');

          if (items.isEmpty) {
            return Column(
              children: [
                SizedBox(height: AppSpacing.sectionTopPadding),
                Text(
                  viewMode == ViewMode.shopping
                      ? 'Nenhum item na lista de compras'
                      : 'Nenhum item comprado',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
              ],
            );
          }

          return Column(
            children: [
              SizedBox(height: AppSpacing.sectionTopPadding),
              Row(
                children: [
                  Icon(
                    viewMode == ViewMode.shopping
                        ? Icons.shopping_cart
                        : Icons.check_circle,
                    color: viewMode == ViewMode.shopping
                        ? AppColors.shoppingIcon
                        : AppColors.purchasedIcon,
                    size: 20,
                  ),
                  SizedBox(width: AppSpacing.iconTextGap),
                  Text(
                    viewMode == ViewMode.shopping
                        ? 'Lista de Compras (${items.length})'
                        : 'Comprado (${items.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.titleSeparatorGap),
              Container(
                height: 1,
                color: AppColors.sectionSeparator,
              ),
              const SizedBox(height: 16),
              ListView.builder(
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
              ),
            ],
          );
        } else if (state is FetchChecklistError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(
            child: Text('Nenhum item disponível.'),
          );
        }
      },
    );
  }
}

class ChecklistSections extends StatelessWidget {
  final List<ShoppingItemEntity> notCompletedItems;
  final List<ShoppingItemEntity> completedItems;
  final Future<void> Function(ShoppingItemEntity) onToggleCompletion;
  final void Function(ShoppingItemEntity) onDeleteItem;
  final void Function(ShoppingItemEntity) onEditItem;

  const ChecklistSections({
    super.key,
    required this.notCompletedItems,
    required this.completedItems,
    required this.onToggleCompletion,
    required this.onDeleteItem,
    required this.onEditItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Lista de Compras Section
        if (notCompletedItems.isNotEmpty) ...[
          SizedBox(height: AppSpacing.sectionTopPadding),
          Row(
            children: [
              const Icon(
                Icons.shopping_cart,
                color: AppColors.shoppingIcon,
                size: 20,
              ),
              SizedBox(width: AppSpacing.iconTextGap),
              Text(
                'Lista de Compras (${notCompletedItems.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.titleSeparatorGap),
          Container(
            height: 1,
            color: AppColors.sectionSeparator,
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notCompletedItems.length,
            itemBuilder: (context, index) {
              return ChecklistItemWidget(
                item: notCompletedItems[index],
                onChanged: (value) =>
                    onToggleCompletion(notCompletedItems[index]),
                onDelete: () => onDeleteItem(notCompletedItems[index]),
                onEdit: () => onEditItem(notCompletedItems[index]),
              );
            },
          ),
        ],

        // Comprado Section
        if (completedItems.isNotEmpty) ...[
          SizedBox(height: AppSpacing.sectionTopPadding),
          Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.purchasedIcon,
                size: 20,
              ),
              SizedBox(width: AppSpacing.iconTextGap),
              Text(
                'Comprado (${completedItems.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.titleSeparatorGap),
          Container(
            height: 1,
            color: AppColors.sectionSeparator,
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: completedItems.length,
            itemBuilder: (context, index) {
              return ChecklistItemWidget(
                item: completedItems[index],
                onChanged: (value) => onToggleCompletion(completedItems[index]),
                onDelete: () => onDeleteItem(completedItems[index]),
                onEdit: () => onEditItem(completedItems[index]),
              );
            },
          ),
        ],
      ],
    );
  }
}
