import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:phosphoricons_flutter_example/main.dart';

void main() {
  testWidgets('example app opens and every tab renders without errors',
      (tester) async {
    await tester.pumpWidget(const ExampleApp());
    await tester.pumpAndSettle();

    // First tab: 6 styles table.
    expect(tester.takeException(), isNull);
    expect(find.text('storefront'), findsOneWidget);
    expect(find.byType(PhosphorIcon), findsWidgets);

    // Duotone tab.
    await tester.tap(find.widgetWithText(Tab, 'Duotone'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Secondary opacity:'), findsOneWidget);

    // Shadows tab: icons are drawn with shadows.
    await tester.tap(find.widgetWithText(Tab, 'Shadows'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final shadowed = tester
        .widgetList<PhosphorIcon>(find.byType(PhosphorIcon))
        .where((icon) => icon.shadows != null && icon.shadows!.isNotEmpty);
    expect(shadowed, isNotEmpty);

    // Shortcuts tab.
    await tester.tap(find.widgetWithText(Tab, 'Shortcuts'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('PhosphorIcons — shortcut class'), findsOneWidget);
  });
}
