// Generates the images listed under `screenshots:` in the package pubspec.yaml
// (shown on the pub.dev page). Skipped in normal test runs. To regenerate:
//
//   cd example
//   GENERATE_SCREENSHOTS=1 flutter test --update-goldens test/screenshots_test.dart
//
// The images are written to ../screenshots/.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphoricons_flutter_example/main.dart';

Future<void> _addFont(FontLoader loader, String path) async {
  final file = File(path);
  if (file.existsSync()) {
    loader.addFont(Future.value(ByteData.sublistView(file.readAsBytesSync())));
  }
}

/// flutter_test does not load fonts on its own: without this, text is drawn
/// with the blocky "Ahem" font and the icons show up as empty squares.
Future<void> _loadFonts() async {
  final root = Platform.environment['FLUTTER_ROOT'];
  if (root != null) {
    final dir = '$root/bin/cache/artifacts/material_fonts';
    for (final family in ['Roboto', 'monospace']) {
      final loader = FontLoader(family);
      for (final file in [
        'Roboto-Regular.ttf',
        'Roboto-Medium.ttf',
        'Roboto-Bold.ttf'
      ]) {
        await _addFont(loader, '$dir/$file');
      }
      await loader.load();
    }
  }

  // The package fonts (the tests run from the example/ directory).
  const fonts = {
    'PhosphorRegular': 'Phosphor.ttf',
    'PhosphorThin': 'Phosphor-Thin.ttf',
    'PhosphorLight': 'Phosphor-Light.ttf',
    'PhosphorBold': 'Phosphor-Bold.ttf',
    'PhosphorFill': 'Phosphor-Fill.ttf',
    'PhosphorDuotone': 'Phosphor-Duotone.ttf',
  };
  for (final entry in fonts.entries) {
    final loader = FontLoader('packages/phosphoricons_flutter/${entry.key}');
    await _addFont(loader, '../lib/fonts/${entry.value}');
    await loader.load();
  }
}

void main() {
  final generate = Platform.environment['GENERATE_SCREENSHOTS'] == '1';

  testWidgets('generate pub.dev screenshots', skip: !generate, (tester) async {
    await _loadFonts();
    // flutter_test draws elevation shadows as solid black outlines by default.
    debugDisableShadows = false;
    addTearDown(() => debugDisableShadows = true);
    // The styles table has 8 rows and needs more height than the other tabs.
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const ExampleApp());
    await tester.pumpAndSettle();
    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('../../screenshots/1_six_styles.png'));

    tester.view.physicalSize = const Size(1200, 800);
    await tester.tap(find.widgetWithText(Tab, 'Duotone'));
    await tester.pumpAndSettle();
    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('../../screenshots/2_duotone.png'));

    await tester.tap(find.widgetWithText(Tab, 'Shadows'));
    await tester.pumpAndSettle();
    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('../../screenshots/3_shadows.png'));
  });
}
