import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

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
          child: Image.asset('assets/images/bag.png', height: 160),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: widget.controller,
          decoration: const InputDecoration(
            hintText: 'Digite o item que deseja adicionar',
            hintStyle: TextStyle(color: AppColors.hint),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
            ),
          ),
          onSubmitted: (value) => _addItem(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _priceController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            hintText: 'Digite o preço (opcional)',
            hintStyle: TextStyle(color: AppColors.hint),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
            ),
          ),
          onSubmitted: (value) => _addItem(),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _addItem,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            backgroundColor: Theme.of(context).primaryColor,
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
