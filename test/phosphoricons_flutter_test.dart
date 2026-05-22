import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

void main() {
  group('Constantes e Integridade', () {
    test('Ícones regulares têm codepoints válidos', () {
      expect(PhosphorIconsRegular.storefront.codePoint, greaterThan(0));
      expect(PhosphorIconsRegular.house.codePoint, greaterThan(0));
    });

    test('Ícones bold têm codepoints válidos', () {
      expect(PhosphorIconsBold.storefront.codePoint, greaterThan(0));
    });

    test('Ícones fill têm codepoints válidos', () {
      expect(PhosphorIconsFill.storefront.codePoint, greaterThan(0));
    });

    test('Duotone tem primary e secondary', () {
      final icon = PhosphorIconsDuotone.storefront;
      expect(icon.primary.codePoint, greaterThan(0));
      expect(icon.secondary.codePoint, greaterThan(0));
    });

    test('PhosphorIcons expõe constantes diretas', () {
      expect(PhosphorIcons.storefront.codePoint, greaterThan(0));
      expect(PhosphorIcons.storefrontBold.codePoint, greaterThan(0));
      expect(PhosphorIcons.storefrontFill.codePoint, greaterThan(0));
    });

    test('PhosphorIcons constantes diretas equivalem às classes de estilo', () {
      expect(PhosphorIcons.storefront, equals(PhosphorIconsRegular.storefront));
      expect(PhosphorIcons.storefrontBold, equals(PhosphorIconsBold.storefront));
      expect(PhosphorIcons.storefrontFill, equals(PhosphorIconsFill.storefront));
    });

    test('Aliases apontam para o mesmo codepoint', () {
      expect(PhosphorIconsRegular.asclepius.codePoint,
          equals(PhosphorIconsRegular.caduceus.codePoint));
    });
  });

  group('Widget PhosphorIcon', () {
    testWidgets('renderiza Icon comum para IconData', (WidgetTester tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: PhosphorIcon(
            PhosphorIconsRegular.storefront,
            color: Colors.red,
            size: 24.0,
            semanticLabel: 'storefront_label',
          ),
        ),
      );

      final iconFinder = find.byType(Icon);
      expect(iconFinder, findsOneWidget);

      final iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.icon, equals(PhosphorIconsRegular.storefront));
      expect(iconWidget.color, equals(Colors.red));
      expect(iconWidget.size, equals(24.0));
      expect(iconWidget.semanticLabel, equals('storefront_label'));
    });

    testWidgets('renderiza Stack com dois Icons para PhosphorDuotoneIconData', (WidgetTester tester) async {
      const duotoneIcon = PhosphorIconsDuotone.storefront;

      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: PhosphorIcon(
            duotoneIcon,
            color: Colors.blue,
            duotoneSecondaryColor: Colors.green,
            duotoneSecondaryOpacity: 0.35,
            size: 30.0,
            semanticLabel: 'duotone_label',
          ),
        ),
      );

      // Deve conter um Stack
      expect(find.byType(Stack), findsOneWidget);

      // Deve conter dois Icons
      final iconFinder = find.byType(Icon);
      expect(iconFinder, findsNWidgets(2));

      // Primeiro Icon: camada de preenchimento (primary) dentro de um Opacity
      final opacityFinder = find.byType(Opacity);
      expect(opacityFinder, findsOneWidget);
      final opacityWidget = tester.widget<Opacity>(opacityFinder);
      expect(opacityWidget.opacity, equals(0.35));

      final firstIconWidget = tester.widget<Icon>(find.descendant(
        of: opacityFinder,
        matching: find.byType(Icon),
      ));
      expect(firstIconWidget.icon, equals(duotoneIcon.primary));
      expect(firstIconWidget.color, equals(Colors.green));
      expect(firstIconWidget.size, equals(30.0));

      // Segundo Icon: camada de traços/linhas (secondary)
      final iconWidgets = tester.widgetList<Icon>(iconFinder).toList();
      final secondIconWidget = iconWidgets[1];
      expect(secondIconWidget.icon, equals(duotoneIcon.secondary));
      expect(secondIconWidget.color, equals(Colors.blue));
      expect(secondIconWidget.size, equals(30.0));
      expect(secondIconWidget.semanticLabel, equals('duotone_label'));
    });

    test('lança AssertionError se o icon não for IconData ou PhosphorDuotoneIconData', () {
      expect(
        () => PhosphorIcon(
          'not_an_icon_data', // String inválida
        ),
        throwsAssertionError,
      );
    });
  });
}
