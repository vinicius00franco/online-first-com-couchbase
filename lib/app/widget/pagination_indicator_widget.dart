import 'package:flutter/material.dart';

class PaginationIndicatorWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const PaginationIndicatorWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            totalPages,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentPage == index ? Theme.of(context).primaryColor : Colors.grey[400],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Página ${currentPage + 1} de $totalPages',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black54),
          ),
        ),
      ],
    );
  }
}