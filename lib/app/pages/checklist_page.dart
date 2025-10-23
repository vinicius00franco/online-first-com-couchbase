// ignore_for_file: use_build_context_synchronously

import 'package:checklist/app/logic/checklist/checklist_cubit.dart';
import 'package:checklist/app/widget/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../entities/shopping_item_entity.dart';
import '../helpers/dialogs.dart';
import '../logic/add_checklist_item/add_checklist_cubit.dart';
import '../logic/delete_checklist_item/delete_checklist_cubit.dart';
import '../logic/update_checklist_item/update_checklist_cubit.dart';
import '../logic/checklist/checklist_state.dart';
import '../services/couchbase_service.dart';
import '../widget/checklist_items_widget.dart';
import '../widget/total_widget.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final textController = TextEditingController();
  // ON/OFF CHECK ITEM
  Future<void> toggleItemCompletion(ShoppingItemEntity item) async {
    await context.read<UpdateChecklistCubit>().updateItem(
          item.id!,
          isCompleted: !item.isCompleted,
        );
    context.read<FetchChecklistCubit>().fetchItems();
  }

  // DELETE ITEM
  void deleteItem(ShoppingItemEntity item) {
    Dialogs.showConfirmationDialog(
      context: context,
      title: 'Confirmação',
      content: 'Deseja excluir o item "${item.title}"?',
      onConfirm: () async {
        await context.read<DeleteChecklistCubit>().deleteItem(item.id!);
        context.read<FetchChecklistCubit>().fetchItems();
      },
    );
  }

  // UPDATE ITEM
  void editItem(ShoppingItemEntity item) {
    TextEditingController controller = TextEditingController(text: item.title);
    TextEditingController priceController = TextEditingController(
      text: item.price > 0 ? item.price.toString() : '',
    );

    Dialogs.showEditDialog(
      context: context,
      title: 'Editar Item',
      controller: controller,
      priceController: priceController,
      onConfirm: () async {
        final newPriceText = priceController.text.trim().replaceAll(',', '.');
        final newPrice = newPriceText.isEmpty
            ? 0.0
            : double.tryParse(newPriceText) ?? item.price;
        print(
            'Editando item ${item.id}: título "${controller.text}", preço: $newPrice');
        await context.read<UpdateChecklistCubit>().updateItem(
              item.id!,
              title: controller.text,
              price: newPrice,
            );
        print('Item editado, buscando itens atualizados...');
        await context.read<FetchChecklistCubit>().fetchItems();
        print('Itens buscados após edição');
      },
    );
  }

  // ADD ITEM
  Future<void> addItem(String title, double price) async {
    await context.read<AddChecklistCubit>().addItem(
          ShoppingItemEntity(
            title: title,
            createdAt: DateTime.now(),
            isCompleted: false,
            price: price,
          ),
        );
    textController.clear();
    context.read<FetchChecklistCubit>().fetchItems();
  }

  Future<void> initApp() async {
    await context.read<FetchChecklistCubit>().fetchItems();
    context.read<CouchbaseService>().startReplication(
      onSynced: () {
        context.read<FetchChecklistCubit>().fetchItems();
      },
    );
    context.read<CouchbaseService>().networkStatusListen();
  }

  @override
  void initState() {
    super.initState();
    initApp();
  }

  @override
  void dispose() {
    context.read<CouchbaseService>().networkConnection?.cancel();
    context.read<CouchbaseService>().replicator?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: AppSpacing.cardPadding,
              child: Column(
                children: [
                  InputWidget(controller: textController, onAddItem: addItem),
                  BlocBuilder<FetchChecklistCubit, FetchChecklistState>(
                    builder: (context, state) {
                      if (state is FetchChecklistLoaded) {
                        return TotalWidget(items: state.items);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 48),
                  ChecklistItemsBuilder(
                    onToggleCompletion: (item) => toggleItemCompletion(item),
                    onDeleteItem: (item) => deleteItem(item),
                    onEditItem: (item) => editItem(item),
                  ),
                ],
              ),
            ),
            const Center(
              child: Text(
                'Desenvolvido por Alura. Projeto fictício sem fins comerciais.',
                style: TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
