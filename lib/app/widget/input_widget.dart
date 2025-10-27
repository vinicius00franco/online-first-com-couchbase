import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import 'custom_text_field_widget.dart';

class InputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String title, double price) onAddItem;

  const InputWidget({
    super.key,
    required this.controller,
    required this.onAddItem,
  });

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final TextEditingController _priceController = TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child:
              Image.asset('assets/images/bag.png', height: AppSpacing.xxl * 3),
        ),
        const SizedBox(height: AppSpacing.lg),
        CustomTextFieldWidget(
          controller: widget.controller,
          hintText: 'Digite o item que deseja adicionar',
          onSubmitted: (value) => _addItem(),
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextFieldWidget(
          controller: _priceController,
          hintText: 'Digite o preço (opcional)',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onSubmitted: (value) => _addItem(),
        ),
        const SizedBox(height: AppSpacing.sm),
        ElevatedButton(
          onPressed: _addItem,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            ),
            padding: AppSpacing.buttonPadding,
            backgroundColor: AppColors.primary,
          ),
          child: const Text(
            'Salvar item',
            style: AppTextStyles.button,
          ),
        ),
      ],
    );
  }

  void _addItem() {
    final title = widget.controller.text.trim();
    final priceText = _priceController.text.trim().replaceAll(',', '.');
    final price = priceText.isEmpty ? 0.0 : double.tryParse(priceText) ?? 0.0;

    if (title.isNotEmpty) {
      widget.onAddItem(title, price);
      widget.controller.clear();
      _priceController.clear();
    }
  }
}
