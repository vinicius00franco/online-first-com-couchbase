// ignore_for_file: use_build_context_synchronously

import 'package:checklist/app/logic/checklist/checklist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../entities/shopping_item_entity.dart';
import '../logic/checklist/checklist_state.dart';
import 'list_section_widget.dart';

class ChecklistItemsBuilder extends StatelessWidget {
  final Future<void> Function(ShoppingItemEntity) onToggleCompletion;
  final void Function(ShoppingItemEntity) onDeleteItem;
  final void Function(ShoppingItemEntity) onEditItem;

  const ChecklistItemsBuilder({
    super.key,
    required this.onToggleCompletion,
    required this.onDeleteItem,
    required this.onEditItem,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchChecklistCubit, FetchChecklistState>(
      builder: (context, state) {
        if (state is FetchChecklistLoading) {
          return const CircularProgressIndicator();
        } else if (state is FetchChecklistLoaded) {
          final items = state.items;

          final notCompletedItems =
              items.where((item) => !item.isCompleted).toList();

          final completedItems =
              items.where((item) => item.isCompleted).toList();

          return ChecklistSections(
            notCompletedItems: notCompletedItems,
            completedItems: completedItems,
            onToggleCompletion: onToggleCompletion,
            onDeleteItem: onDeleteItem,
            onEditItem: onEditItem,
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
        ListSectionWidget(
          title: 'Lista de Compras',
          items: notCompletedItems,
          onToggleCompletion: (index) =>
              onToggleCompletion(notCompletedItems[index]),
          onDeleteItem: (index) => onDeleteItem(notCompletedItems[index]),
          onEditItem: (index) => onEditItem(notCompletedItems[index]),
        ),
        ListSectionWidget(
          title: 'Comprado',
          items: completedItems,
          onToggleCompletion: (index) =>
              onToggleCompletion(completedItems[index]),
          onDeleteItem: (index) => onDeleteItem(completedItems[index]),
          onEditItem: (index) => onEditItem(completedItems[index]),
        ),
      ],
    );
  }
}
