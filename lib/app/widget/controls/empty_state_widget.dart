import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../checklist_items_widget.dart';

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
          style: AppTextStyles.bodyLarge,
        ),
        SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
