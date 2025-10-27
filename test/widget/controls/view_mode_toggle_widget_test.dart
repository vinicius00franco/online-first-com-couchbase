import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:checklist/app/entities/view_mode_enum.dart';
import 'package:checklist/app/widget/controls/view_mode_toggle_widget.dart';

void main() {
  group('ViewModeToggleWidget', () {
    testWidgets('displays shopping cart icon for shopping mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ViewModeToggleWidget(
              currentView: ViewModeEnum.shopping,
              onSwitch: (_) {},
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
            body: ViewModeToggleWidget(
              currentView: ViewModeEnum.purchased,
              onSwitch: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('Comprados'), findsNothing);
    });

    testWidgets('calls onSwitch when shopping button is tapped',
        (WidgetTester tester) async {
      ViewModeEnum? switchedTo;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ViewModeToggleWidget(
              currentView: ViewModeEnum.purchased,
              onSwitch: (mode) => switchedTo = mode,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.shopping_cart));
      expect(switchedTo, ViewModeEnum.shopping);
    });

    testWidgets('calls onSwitch when purchased button is tapped',
        (WidgetTester tester) async {
      ViewModeEnum? switchedTo;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ViewModeToggleWidget(
              currentView: ViewModeEnum.shopping,
              onSwitch: (mode) => switchedTo = mode,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.check));
      expect(switchedTo, ViewModeEnum.purchased);
    });
  });
}
