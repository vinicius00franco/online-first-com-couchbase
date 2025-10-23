// ignore_for_file: use_build_context_synchronously

import 'package:checklist/app/logic/checklist/checklist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../entities/shopping_item_entity.dart';
import '../logic/checklist/checklist_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../utils/logger.dart' as app_logger;
import '../theme/app_theme.dart';
import 'ui/section_header_widget.dart';
import 'ui/pagination_indicator_widget.dart';
import 'items_page_widget.dart';
import 'estado_controle/empty_state_widget.dart';

enum ViewMode { shopping, purchased }

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
              Divider(
                thickness: AppTheme.separatorHeight,
                color: AppColors.sectionSeparator,
              ),
              SizedBox(height: AppSpacing.md),
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
              SizedBox(height: AppSpacing.sm),
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
