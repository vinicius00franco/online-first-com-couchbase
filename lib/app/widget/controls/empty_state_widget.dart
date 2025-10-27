import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../entities/view_mode_enum.dart';

class EmptyStateWidget extends StatelessWidget {
  final ViewModeEnum viewMode;

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
          viewMode == ViewModeEnum.shopping
              ? 'Nenhum item na lista de compras'
              : 'Nenhum item comprado',
          style: AppTextStyles.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
