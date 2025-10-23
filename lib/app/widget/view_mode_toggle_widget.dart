import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import 'checklist_items_widget.dart';

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
              backgroundColor: currentView == ViewMode.shopping ? Theme.of(context).primaryColor : AppColors.buttonInactive,
              foregroundColor: currentView == ViewMode.shopping ? AppColors.buttonActiveText : AppColors.buttonInactiveText,
              padding: AppSpacing.buttonPadding,
              fixedSize: const Size(double.infinity, AppTheme.buttonHeight),
            ),
            child: const Text('Lista de Compras', textAlign: TextAlign.center),
          ),
        ),
        const SizedBox(width: AppSpacing.buttonGap),
        Expanded(
          child: ElevatedButton(
            onPressed: () => onSwitch(ViewMode.purchased),
            style: ElevatedButton.styleFrom(
              backgroundColor: currentView == ViewMode.purchased ? Theme.of(context).primaryColor : AppColors.buttonInactive,
              foregroundColor: currentView == ViewMode.purchased ? AppColors.buttonActiveText : AppColors.buttonInactiveText,
              padding: AppSpacing.buttonPadding,
              fixedSize: const Size(double.infinity, AppTheme.buttonHeight),
            ),
            child: const Text('Comprados', textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }
}