// Generates the small PNG previews used in the dartdoc of every icon constant
// (shown in IDE hover and on pub.dev). VS Code does not render remote SVGs in
// hovers, but it does render PNGs. Skipped in normal test runs. To regenerate:
//
//   cd example
//   GENERATE_DOC_ICONS=1 flutter test test/doc_icons_test.dart
//
// The images are written to ../doc/icons/<style>/<name>.png (kebab-case name).
// Set DOC_ICONS_ONLY=acorn,heart to render just a few while experimenting.

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const _size = 48;
const _gray = 0x88;
const _color = Color(_gray << 16 | _gray << 8 | _gray | 0xFF000000);
const _duotoneFillOpacity = 0.2;

const _styles = {
  'regular': ('PhosphorRegular', 'Phosphor.ttf'),
  'thin': ('PhosphorThin', 'Phosphor-Thin.ttf'),
  'light': ('PhosphorLight', 'Phosphor-Light.ttf'),
  'bold': ('PhosphorBold', 'Phosphor-Bold.ttf'),
  'fill': ('PhosphorFill', 'Phosphor-Fill.ttf'),
  'duotone': ('PhosphorDuotone', 'Phosphor-Duotone.ttf'),
};

String _family(String style) =>
    'packages/phosphoricons_flutter/${_styles[style]!.$1}';

String _kebab(String camel) => camel.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (m) => '-${m.group(0)!.toLowerCase()}',
    );

Future<void> _loadFonts() async {
  for (final entry in _styles.entries) {
    final loader = FontLoader(_family(entry.key));
    final bytes = File('../lib/fonts/${entry.value.$2}').readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
    await loader.load();
  }
}

/// name (camelCase) -> codepoints (1 for flat styles, 2 for duotone).
Map<String, List<int>> _readIcons(String style) {
  final source =
      File('../lib/src/phosphor_icons_$style.dart').readAsStringSync();
  final icons = <String, List<int>>{};
  if (style == 'duotone') {
    final re = RegExp(
      r'static const (\w+)\s*=\s*PhosphorDuotoneIconData\(\s*IconData\(\s*0x([0-9a-fA-F]+),[^)]*\),\s*IconData\(\s*0x([0-9a-fA-F]+),',
    );
    for (final m in re.allMatches(source)) {
      icons[m.group(1)!] = [
        int.parse(m.group(2)!, radix: 16),
        int.parse(m.group(3)!, radix: 16)
      ];
    }
  } else {
    final re = RegExp(
        r'static const IconData (\w+)\s*=\s*IconData\(\s*0x([0-9a-fA-F]+),');
    for (final m in re.allMatches(source)) {
      icons[m.group(1)!] = [int.parse(m.group(2)!, radix: 16)];
    }
  }
  return icons;
}

void _paintGlyph(Canvas canvas, int codePoint, String family, Color color) {
  final painter = TextPainter(
    text: TextSpan(
      text: String.fromCharCode(codePoint),
      style: TextStyle(
        fontFamily: family,
        fontSize: _size.toDouble(),
        height: 1.0,
        leadingDistribution: TextLeadingDistribution.even,
        color: color,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  painter.paint(
    canvas,
    Offset((_size - painter.width) / 2, (_size - painter.height) / 2),
  );
}

Future<Uint8List> _render(String style, List<int> codePoints) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final family = _family(style);
  if (style == 'duotone') {
    // codePoints[0] is the fill layer (faded), codePoints[1] the strokes.
    _paintGlyph(canvas, codePoints[0], family,
        _color.withValues(alpha: _duotoneFillOpacity));
    _paintGlyph(canvas, codePoints[1], family, _color);
  } else {
    _paintGlyph(canvas, codePoints[0], family, _color);
  }
  final image = await recorder.endRecording().toImage(_size, _size);
  final data =
      await image.toByteData(format: ui.ImageByteFormat.rawStraightRgba);
  image.dispose();
  return _encodePng(data!.buffer.asUint8List(), _size, _size);
}

/// Encodes a grayscale + alpha PNG. Every pixel has the same colour (_gray) and
/// only the alpha varies, so this is about half the size of the RGBA PNG that
/// `Image.toByteData(png)` produces, with the exact same pixels.
Uint8List _encodePng(Uint8List rgba, int width, int height) {
  final stride = width * 2;
  final rows = [
    for (var y = 0; y < height; y++)
      Uint8List.fromList([
        for (var x = 0; x < width; x++) ...[
          _gray,
          rgba[(y * width + x) * 4 + 3]
        ],
      ]),
  ];

  // Try the "none", "sub" and "up" PNG filters and keep the smallest result.
  Uint8List? best;
  for (final filter in [0, 1, 2]) {
    final raw = BytesBuilder();
    var previous = Uint8List(stride);
    for (final row in rows) {
      raw.addByte(filter);
      for (var i = 0; i < stride; i++) {
        final base = switch (filter) {
          1 => i >= 2 ? row[i - 2] : 0,
          2 => previous[i],
          _ => 0,
        };
        raw.addByte((row[i] - base) & 0xFF);
      }
      previous = row;
    }
    final compressed =
        Uint8List.fromList(ZLibCodec(level: 9).encode(raw.toBytes()));
    if (best == null || compressed.length < best.length) best = compressed;
  }

  final header = ByteData(13)
    ..setUint32(0, width)
    ..setUint32(4, height)
    ..setUint8(8, 8) // bit depth
    ..setUint8(9, 4); // colour type: grayscale + alpha
  return (BytesBuilder()
        ..add(const [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])
        ..add(_chunk('IHDR', header.buffer.asUint8List()))
        ..add(_chunk('IDAT', best!))
        ..add(_chunk('IEND', Uint8List(0))))
      .toBytes();
}

Uint8List _chunk(String type, Uint8List data) {
  final typeBytes = type.codeUnits;
  final out = ByteData(12 + data.length);
  out.setUint32(0, data.length);
  final bytes = out.buffer.asUint8List();
  bytes.setRange(4, 8, typeBytes);
  bytes.setRange(8, 8 + data.length, data);
  out.setUint32(8 + data.length, _crc32([...typeBytes, ...data]));
  return bytes;
}

final _crcTable = List<int>.generate(256, (n) {
  var c = n;
  for (var k = 0; k < 8; k++) {
    c = c & 1 != 0 ? 0xEDB88320 ^ (c >> 1) : c >> 1;
  }
  return c;
});

int _crc32(List<int> bytes) {
  var c = 0xFFFFFFFF;
  for (final b in bytes) {
    c = _crcTable[(c ^ b) & 0xFF] ^ (c >> 8);
  }
  return c ^ 0xFFFFFFFF;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final generate = Platform.environment['GENERATE_DOC_ICONS'] == '1';
  final only = Platform.environment['DOC_ICONS_ONLY']?.split(',').toSet();

  test('generate doc icon PNGs', skip: !generate, () async {
    await _loadFonts();
    var count = 0;
    for (final style in _styles.keys) {
      final dir = Directory('../doc/icons/$style')..createSync(recursive: true);
      for (final entry in _readIcons(style).entries) {
        if (only != null && !only.contains(entry.key)) continue;
        final png = await _render(style, entry.value);
        File('${dir.path}/${_kebab(entry.key)}.png').writeAsBytesSync(png);
        count++;
      }
    }
    // ignore: avoid_print
    print('Wrote $count PNGs to doc/icons/');
    expect(count, greaterThan(0));
  });
}
