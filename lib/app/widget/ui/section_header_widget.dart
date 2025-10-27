import 'package:flutter/material.dart';
import '../../theme/app_text_styles.dart';
import '../../entities/view_mode_enum.dart';

class SectionHeaderWidget extends StatelessWidget {
  final ViewModeEnum viewMode;
  final int itemCount;

  const SectionHeaderWidget({
    super.key,
    required this.viewMode,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    final title = viewMode == ViewModeEnum.shopping
        ? 'Lista de Compras'
        : 'Itens Comprados';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.h2,
        ),
        Text(
          '$itemCount itens',
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}
