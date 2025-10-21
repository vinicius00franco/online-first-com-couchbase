import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class InputWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAddItem;

  const InputWidget({
    super.key,
    required this.controller,
    required this.onAddItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Image.asset('assets/images/bag.png', height: 160),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: controller,
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
          onSubmitted: (value) => onAddItem(),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: onAddItem,
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
}
