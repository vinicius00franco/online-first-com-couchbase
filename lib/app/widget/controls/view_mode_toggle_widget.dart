import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_theme.dart';
import '../../entities/view_mode_enum.dart';

class ViewModeToggleWidget extends StatelessWidget {
  final ViewModeEnum currentView;
  final void Function(ViewModeEnum) onSwitch;

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
            onPressed: () => onSwitch(ViewModeEnum.shopping),
            style: ElevatedButton.styleFrom(
              backgroundColor: currentView == ViewModeEnum.shopping
                  ? AppColors.primary
                  : AppColors.buttonInactive,
              foregroundColor: currentView == ViewModeEnum.shopping
                  ? AppColors.onPrimary
                  : AppColors.onSurface,
              padding: AppSpacing.buttonPadding,
              fixedSize: const Size(double.infinity, AppTheme.buttonHeight),
            ),
            child: const Text('Lista de Compras', textAlign: TextAlign.center),
          ),
        ),
        const SizedBox(width: AppSpacing.buttonGap),
        Expanded(
          child: ElevatedButton(
            onPressed: () => onSwitch(ViewModeEnum.purchased),
            style: ElevatedButton.styleFrom(
              backgroundColor: currentView == ViewModeEnum.purchased
                  ? AppColors.primary
                  : AppColors.buttonInactive,
              foregroundColor: currentView == ViewModeEnum.purchased
                  ? AppColors.onPrimary
                  : AppColors.onSurface,
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
