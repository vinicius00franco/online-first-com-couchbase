// ignore_for_file: use_build_context_synchronously

import 'package:checklist/app/logic/checklist/checklist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../entities/shopping_item_entity.dart';
import '../logic/checklist/checklist_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import '../utils/logger.dart' as app_logger;
import 'check_item_widget.dart';

enum ViewMode { shopping, purchased }

class SectionHeaderWidget extends StatelessWidget {
  final ViewMode viewMode;
  final int itemCount;

  const SectionHeaderWidget({
    super.key,
    required this.viewMode,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
        const SizedBox(width: AppSpacing.iconTextGap),
        Text(
          viewMode == ViewMode.shopping
              ? 'Lista de Compras ($itemCount)'
              : 'Comprado ($itemCount)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
        ),
      ],
    );
  }
}

class PaginationIndicatorWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const PaginationIndicatorWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Indicador de swipe: dots para páginas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            totalPages,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentPage == index
                    ? Theme.of(context).primaryColor
                    : Colors.grey[400],
              ),
            ),
          ),
        ),
        // Indicador simples de página
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Página ${currentPage + 1} de $totalPages',
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: Colors.black54),
          ),
        ),
      ],
    );
  }
}

class ViewModeToggleWidget extends StatelessWidget {
  final ViewMode currentView;
  final void Function(ViewMode) onSwitch;

  const ViewModeToggleWidget({
    super.key,
    required this.currentView,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => onSwitch(ViewMode.shopping),
            style: ElevatedButton.styleFrom(
              backgroundColor: currentView == ViewMode.shopping
                  ? Theme.of(context).primaryColor
                  : AppColors.buttonInactive,
              foregroundColor: currentView == ViewMode.shopping
                  ? AppColors.buttonActiveText
                  : AppColors.buttonInactiveText,
              padding: AppSpacing.buttonPadding,
              fixedSize: const Size(
                double.infinity,
                AppTheme.buttonHeight,
              ),
            ),
            child: const Text(
              'Lista de Compras',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.buttonGap),
        Expanded(
          child: ElevatedButton(
            onPressed: () => onSwitch(ViewMode.purchased),
            style: ElevatedButton.styleFrom(
              backgroundColor: currentView == ViewMode.purchased
                  ? Theme.of(context).primaryColor
                  : AppColors.buttonInactive,
              foregroundColor: currentView == ViewMode.purchased
                  ? AppColors.buttonActiveText
                  : AppColors.buttonInactiveText,
              padding: AppSpacing.buttonPadding,
              fixedSize: const Size(
                double.infinity,
                AppTheme.buttonHeight,
              ),
            ),
            child: const Text(
              'Comprados',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final void Function(String)? onSubmitted;

  const CustomTextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.hint),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
      ),
      onSubmitted: onSubmitted,
    );
  }
}

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

class EmptyStateWidget extends StatelessWidget {
  final ViewMode viewMode;

  const EmptyStateWidget({
    super.key,
    required this.viewMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.sectionTopPadding),
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
}

class ChecklistItemsBuilder extends StatefulWidget {
  final ViewMode viewMode; // Alterna entre listas
  final Future<void> Function(ShoppingItemEntity) onToggleCompletion;
  final void Function(ShoppingItemEntity) onDeleteItem;
  final void Function(ShoppingItemEntity) onEditItem;

  const ChecklistItemsBuilder({
    super.key,
    required this.viewMode,
    required this.onToggleCompletion,
    required this.onDeleteItem,
    required this.onEditItem,
  });

  @override
  State<ChecklistItemsBuilder> createState() => _ChecklistItemsBuilderState();
}

class _ChecklistItemsBuilderState extends State<ChecklistItemsBuilder> {
  // Controle de paginação interna (6 itens por página)
  static const int _pageSize = 6;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    app_logger.Logger.instance
        .info('ChecklistItemsBuilder: Reconstruindo widget');
    return BlocBuilder<FetchChecklistCubit, FetchChecklistState>(
      builder: (context, state) {
        app_logger.Logger.instance
            .info('ChecklistItemsBuilder: Estado recebido: $state');
        if (state is FetchChecklistLoading) {
          return const CircularProgressIndicator();
        } else if (state is FetchChecklistLoaded) {
          final all = widget.viewMode == ViewMode.shopping
              ? state.items.where((item) => !item.isCompleted).toList()
              : state.items.where((item) => item.isCompleted).toList();

          app_logger.Logger.instance.info(
              'ChecklistItemsBuilder: ${all.length} itens carregados para modo ${widget.viewMode}');

          if (all.isEmpty) {
            return EmptyStateWidget(viewMode: widget.viewMode);
          }

          // Paginação: divide em páginas de 6 itens
          final totalPages = (all.length + _pageSize - 1) ~/ _pageSize;
          final pages = List.generate(
            totalPages,
            (i) => all.skip(i * _pageSize).take(_pageSize).toList(),
          );

          // Altura adaptativa baseada na tela (50% da altura da tela)
          final screenHeight = MediaQuery.of(context).size.height;
          final pageHeight = screenHeight * 0.5;

          return Column(
            children: [
              const SizedBox(height: AppSpacing.sectionTopPadding),
              SectionHeaderWidget(
                viewMode: widget.viewMode,
                itemCount: all.length,
              ),
              const SizedBox(height: AppSpacing.titleSeparatorGap),
              const Divider(
                thickness: 1,
                color: AppColors.sectionSeparator,
              ),
              const SizedBox(height: 16),
              // PageView com swipe lateral entre páginas de itens
              SizedBox(
                height: pageHeight,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, pageIndex) {
                    final items = pages[pageIndex];
                    return ItemsPageWidget(
                      items: items,
                      onToggleCompletion: widget.onToggleCompletion,
                      onDeleteItem: widget.onDeleteItem,
                      onEditItem: widget.onEditItem,
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              // Indicador de swipe: dots para páginas
              if (pages.length > 1)
                PaginationIndicatorWidget(
                  currentPage: _currentPage,
                  totalPages: pages.length,
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
