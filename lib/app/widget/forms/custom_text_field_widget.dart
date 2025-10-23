import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final void Function(String)? onSubmitted;

  const CustomTextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.hint),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24.0))),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24.0))),
      ),
      onSubmitted: onSubmitted,
    );
  }
}
