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
          child: _buildButton(ViewModeEnum.shopping, Icons.shopping_cart),
        ),
        const SizedBox(width: AppSpacing.buttonGap),
        Expanded(
          child: _buildButton(ViewModeEnum.purchased, Icons.check),
        ),
      ],
    );
  }

  Widget _buildButton(ViewModeEnum mode, IconData icon) {
    final isSelected = currentView == mode;
    return ElevatedButton(
      onPressed: () => onSwitch(mode),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? AppColors.primary : AppColors.buttonInactive,
        foregroundColor: isSelected ? AppColors.onPrimary : AppColors.onSurface,
        padding: AppSpacing.buttonPadding,
        fixedSize: const Size(double.infinity, AppTheme.buttonHeight),
      ),
      child: Icon(icon),
    );
  }
}
