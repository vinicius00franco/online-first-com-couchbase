import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:checklist/app/entities/view_mode_enum.dart';
import 'package:checklist/app/widget/ui/section_header_widget.dart';

void main() {
  group('SectionHeaderWidget', () {
    testWidgets('displays shopping cart icon for shopping mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionHeaderWidget(
              viewMode: ViewModeEnum.shopping,
              itemCount: 5,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.text('Lista de Compras'), findsNothing);
    });

    testWidgets('displays check icon for purchased mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionHeaderWidget(
              viewMode: ViewModeEnum.purchased,
              itemCount: 3,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('Itens Comprados'), findsNothing);
    });

    testWidgets('has a colored background box', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionHeaderWidget(
              viewMode: ViewModeEnum.shopping,
              itemCount: 5,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.decoration, isNotNull);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, isNotNull);
    });
  });
}
