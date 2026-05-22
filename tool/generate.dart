// Gerador automático de ícones para phosphoricons_flutter.
//
// Uso (a partir da pasta tool/):
//   dart pub get
//   dart generate.dart
//
// Fonte dos dados: ../phosphor-icons/Fonts/<estilo>/
//   - selection.json → nomes e codepoints
//   - Phosphor-<Estilo>.ttf → copiado para ../lib/fonts/
//
// Para atualizar com novos ícones:
//   1. Baixar novo zip do site phosphoricons.com
//   2. Substituir a pasta ../phosphor-icons/Fonts/
//   3. Rodar este script novamente

import 'dart:convert';
import 'dart:io';

const _package = 'phosphoricons_flutter';

// Raiz dos assets baixados do site oficial
const _sourceBase = '../phosphor-icons/Fonts';

const _styles = [
  _StyleConfig('regular', 'Regular', 'Phosphor.ttf', 'PhosphorRegular'),
  _StyleConfig('thin', 'Thin', 'Phosphor-Thin.ttf', 'PhosphorThin'),
  _StyleConfig('light', 'Light', 'Phosphor-Light.ttf', 'PhosphorLight'),
  _StyleConfig('bold', 'Bold', 'Phosphor-Bold.ttf', 'PhosphorBold'),
  _StyleConfig('fill', 'Fill', 'Phosphor-Fill.ttf', 'PhosphorFill'),
  _StyleConfig('duotone', 'Duotone', 'Phosphor-Duotone.ttf', 'PhosphorDuotone'),
];

void main() {
  print('=== phosphoricons_flutter — gerador de ícones ===\n');

  final oldIcons = _getOldIcons();

  Directory('../lib/fonts').createSync(recursive: true);
  Directory('../lib/src').createSync(recursive: true);

  // allIcons: camelName → { styleId: codepoint }
  final allIcons = <String, Map<String, int>>{};
  // duotoneData: camelName → { primary: cp, secondary: cp }
  final duotoneData = <String, Map<String, int>>{};

  for (final style in _styles) {
    print('Processando: ${style.styleName}');

    // 1. Copiar fonte TTF
    final srcFont = File('$_sourceBase/${style.id}/${style.fontFileName}');
    final dstFont = File('../lib/fonts/${style.fontFileName}');
    if (!srcFont.existsSync()) {
      print('  ERRO: fonte não encontrada em ${srcFont.path}');
      continue;
    }
    srcFont.copySync(dstFont.path);
    final kb = (srcFont.lengthSync() / 1024).toStringAsFixed(0);
    print('  Fonte copiada: ${style.fontFileName} (${kb} KB)');

    // 2. Ler selection.json
    final selectionFile = File('$_sourceBase/${style.id}/selection.json');
    if (!selectionFile.existsSync()) {
      print('  ERRO: selection.json não encontrado');
      continue;
    }

    final json = jsonDecode(selectionFile.readAsStringSync()) as Map<String, dynamic>;
    final icons = json['icons'] as List<dynamic>;

    // 3. Extrair codepoints
    int count = 0;
    for (final entry in icons) {
      final props = entry['properties'] as Map<String, dynamic>;
      // Alguns ícones têm múltiplos aliases separados por vírgula:
      // "asclepius, caduceus" ou "asclepius-bold, caduceus-bold"
      // Geramos constantes para TODOS os aliases (mesmo codepoint)
      final rawNames = (props['name'] as String)
          .split(',')
          .map((n) => n.trim())
          .where((n) => n.isNotEmpty)
          .toList();

      if (style.id == 'duotone') {
        final codes = props['codes'] as List<dynamic>?;
        final primary = props['code'] as int;
        final secondary = codes != null && codes.length > 1
            ? codes[1] as int
            : primary + 1;

        for (final rawName in rawNames) {
          final cleanName = rawName.replaceAll(RegExp(r'[-_]duotone$'), '');
          final camelName = _toCamelCase(cleanName);
          duotoneData[camelName] = {'primary': primary, 'secondary': secondary};
        }
      } else {
        final code = props['code'] as int;
        for (final rawName in rawNames) {
          final cleanName = rawName
              .replaceAll(RegExp(r'[-_](regular|thin|light|bold|fill)$'), '');
          final camelName = _toCamelCase(cleanName);
          allIcons.putIfAbsent(camelName, () => {});
          allIcons[camelName]![style.id] = code;
        }
      }
      count++;
    }
    print('  $count ícones lidos\n');

    // 4. Gerar arquivo .dart do estilo
    final content = style.id == 'duotone'
        ? _generateDuotoneFile(style, duotoneData)
        : _generateFlatFile(style, allIcons);

    File('../lib/src/phosphor_icons_${style.id}.dart').writeAsStringSync(content);
    print('  → lib/src/phosphor_icons_${style.id}.dart\n');
  }

  // 5. Gerar classe base PhosphorIcons
  print('Gerando PhosphorIcons...');
  File('../lib/src/phosphor_icons.dart')
      .writeAsStringSync(_generateBaseFile(allIcons, duotoneData));
  print('  → lib/src/phosphor_icons.dart\n');

  if (oldIcons.isNotEmpty) {
    final added = allIcons.keys.where((k) => !oldIcons.contains(k)).toList()..sort();
    final removed = oldIcons.where((k) => !allIcons.keys.contains(k)).toList()..sort();
    
    print('--- Relatório de Alterações (Diff) ---');
    if (added.isNotEmpty) {
      print('Novos ícones (${added.length}):');
      print('  ${added.join(', ')}');
    } else {
      print('Nenhum ícone novo.');
    }
    
    if (removed.isNotEmpty) {
      print('Ícones removidos (${removed.length}):');
      print('  ${removed.join(', ')}');
    }
    print('--------------------------------------\n');

    final diffBuf = StringBuffer();
    diffBuf.writeln('# Atualização de Ícones (Diff)');
    diffBuf.writeln();
    if (added.isNotEmpty) {
      diffBuf.writeln('### Novos ícones (${added.length})');
      for (final a in added) {
        diffBuf.writeln('* `$a`');
      }
      diffBuf.writeln();
    } else {
      diffBuf.writeln('Nenhum ícone novo adicionado nesta atualização.');
      diffBuf.writeln();
    }
    if (removed.isNotEmpty) {
      diffBuf.writeln('### Ícones removidos (${removed.length})');
      for (final r in removed) {
        diffBuf.writeln('* `$r`');
      }
      diffBuf.writeln();
    }
    File('../NEW_ICONS.md').writeAsStringSync(diffBuf.toString());
    print('  → Arquivo NEW_ICONS.md gerado com o relatório detalhado!');
  }

  print('=== Concluído! ===');
  print('Ícones únicos: ${allIcons.length}');
  print('Duotones: ${duotoneData.length}');
  print('Total de constantes: ~${allIcons.length * 5 + duotoneData.length}');
}

// ─── Geração do arquivo flat (regular / thin / light / bold / fill) ──────────

String _generateFlatFile(
  _StyleConfig style,
  Map<String, Map<String, int>> allIcons,
) {
  final names = allIcons.keys
      .where((n) => allIcons[n]!.containsKey(style.id))
      .toList()
    ..sort();

  final buf = StringBuffer();
  _writeHeader(buf);
  buf.writeln("import 'package:flutter/widgets.dart';");
  buf.writeln();
  buf.writeln('/// Phosphor icons — ${style.styleName} style.');
  buf.writeln('///');
  buf.writeln('/// [PT] Ícones Phosphor — estilo ${style.styleName}.');
  buf.writeln('///');
  buf.writeln('/// ```dart');
  buf.writeln('/// Icon(PhosphorIcons${style.styleName}.storefront)');
  buf.writeln('/// PhosphorIcon(PhosphorIcons${style.styleName}.storefront)');
  buf.writeln('/// ```');
  buf.writeln('@staticIconProvider');
  buf.writeln('class PhosphorIcons${style.styleName} {');
  buf.writeln('  const PhosphorIcons${style.styleName}();');
  buf.writeln();

  for (final name in names) {
    final cp = allIcons[name]![style.id]!;
    buf.writeln('  /// ![${_toKebabCase(name)}](https://raw.githubusercontent.com/phosphor-icons/core/main/assets/${style.id}/${_toKebabCase(name)}.svg)');
    buf.writeln('  static const IconData $name = IconData(');
    buf.writeln('    0x${cp.toRadixString(16)},');
    buf.writeln("    fontFamily: '${style.fontFamily}',");
    buf.writeln("    fontPackage: '$_package',");
    buf.writeln('    matchTextDirection: true,');
    buf.writeln('  );');
    buf.writeln();
  }

  buf.writeln('}');
  return buf.toString();
}

// ─── Geração do arquivo duotone ───────────────────────────────────────────────

String _generateDuotoneFile(
  _StyleConfig style,
  Map<String, Map<String, int>> duotoneData,
) {
  final names = duotoneData.keys.toList()..sort();

  final buf = StringBuffer();
  _writeHeader(buf);
  buf.writeln("import 'package:flutter/widgets.dart';");
  buf.writeln("import 'phosphor_icon_data.dart';");
  buf.writeln();
  buf.writeln('/// Phosphor icons — Duotone style.');
  buf.writeln('///');
  buf.writeln('/// [PT] Ícones Phosphor — estilo Duotone.');
  buf.writeln('///');
  buf.writeln('/// Use with [PhosphorIcon] to render the two color layers:');
  buf.writeln('/// [PT] Use com PhosphorIcon para renderizar as duas camadas de cor:');
  buf.writeln('/// ```dart');
  buf.writeln('/// PhosphorIcon(PhosphorIconsDuotone.storefront, color: Colors.blue)');
  buf.writeln('/// PhosphorIcon(');
  buf.writeln('///   PhosphorIconsDuotone.storefront,');
  buf.writeln('///   color: Colors.blue,');
  buf.writeln('///   duotoneSecondaryColor: Colors.purple,');
  buf.writeln('///   duotoneSecondaryOpacity: 0.4,');
  buf.writeln('/// )');
  buf.writeln('/// ```');
  buf.writeln('@staticIconProvider');
  buf.writeln('class PhosphorIconsDuotone {');
  buf.writeln('  const PhosphorIconsDuotone();');
  buf.writeln();

  for (final name in names) {
    final data = duotoneData[name]!;
    final primary = data['primary']!;
    final secondary = data['secondary']!;
    buf.writeln('  /// ![${_toKebabCase(name)}-duotone](https://raw.githubusercontent.com/phosphor-icons/core/main/assets/duotone/${_toKebabCase(name)}-duotone.svg)');
    buf.writeln('  static const $name = PhosphorDuotoneIconData(');
    buf.writeln('    IconData(');
    buf.writeln('      0x${primary.toRadixString(16)},');
    buf.writeln("      fontFamily: '${style.fontFamily}',");
    buf.writeln("      fontPackage: '$_package',");
    buf.writeln('      matchTextDirection: true,');
    buf.writeln('    ),');
    buf.writeln('    IconData(');
    buf.writeln('      0x${secondary.toRadixString(16)},');
    buf.writeln("      fontFamily: '${style.fontFamily}',");
    buf.writeln("      fontPackage: '$_package',");
    buf.writeln('      matchTextDirection: true,');
    buf.writeln('    ),');
    buf.writeln('  );');
    buf.writeln();
  }

  buf.writeln('}');
  return buf.toString();
}

// ─── Geração da classe base PhosphorIcons ─────────────────────────────────────

String _generateBaseFile(
  Map<String, Map<String, int>> allIcons,
  Map<String, Map<String, int>> duotoneData,
) {
  final sortedNames = allIcons.keys.toList()..sort();

  final buf = StringBuffer();
  _writeHeader(buf);
  buf.writeln("import 'package:flutter/widgets.dart';");
  buf.writeln("import 'phosphor_icons_regular.dart';");
  buf.writeln("import 'phosphor_icons_thin.dart';");
  buf.writeln("import 'phosphor_icons_light.dart';");
  buf.writeln("import 'phosphor_icons_bold.dart';");
  buf.writeln("import 'phosphor_icons_fill.dart';");
  buf.writeln("import 'phosphor_icons_duotone.dart';");
  buf.writeln();
  buf.writeln('/// Central shortcut for all Phosphor icons.');
  buf.writeln('///');
  buf.writeln('/// [PT] Atalho central para todos os ícones Phosphor.');
  buf.writeln('///');
  buf.writeln('/// Two ways to use:');
  buf.writeln('/// [PT] Duas formas de uso:');
  buf.writeln('///');
  buf.writeln('/// ```dart');
  buf.writeln('/// // 1. Via style class (classic way) / Via classe de estilo (forma clássica)');
  buf.writeln('/// Icon(PhosphorIconsRegular.storefront)');
  buf.writeln('/// Icon(PhosphorIconsBold.storefront)');
  buf.writeln('/// PhosphorIcon(PhosphorIconsDuotone.storefront)');
  buf.writeln('///');
  buf.writeln('/// // 2. Direct constant with style suffix / Constante direta com sufixo de estilo');
  buf.writeln('/// Icon(PhosphorIcons.storefront)          // regular (default/padrão)');
  buf.writeln('/// Icon(PhosphorIcons.storefrontBold)      // bold');
  buf.writeln('/// Icon(PhosphorIcons.storefrontFill)      // fill');
  buf.writeln('/// Icon(PhosphorIcons.storefrontThin)      // thin');
  buf.writeln('/// Icon(PhosphorIcons.storefrontLight)     // light');
  buf.writeln('/// PhosphorIcon(PhosphorIcons.storefrontDuotone) // duotone');
  buf.writeln('/// ```');
  buf.writeln('@staticIconProvider');
  buf.writeln('class PhosphorIcons {');

  for (final name in sortedNames) {
    final styles = allIcons[name]!;
    if (styles.containsKey('regular')) {
      buf.writeln('  static const IconData $name = PhosphorIconsRegular.$name;');
    }
    if (styles.containsKey('thin')) {
      buf.writeln('  static const IconData ${name}Thin = PhosphorIconsThin.$name;');
    }
    if (styles.containsKey('light')) {
      buf.writeln('  static const IconData ${name}Light = PhosphorIconsLight.$name;');
    }
    if (styles.containsKey('bold')) {
      buf.writeln('  static const IconData ${name}Bold = PhosphorIconsBold.$name;');
    }
    if (styles.containsKey('fill')) {
      buf.writeln('  static const IconData ${name}Fill = PhosphorIconsFill.$name;');
    }
    if (duotoneData.containsKey(name)) {
      buf.writeln('  static const ${name}Duotone = PhosphorIconsDuotone.$name;');
    }
    buf.writeln();
  }

  buf.writeln('}');
  return buf.toString();
}

// ─── Utilitários ─────────────────────────────────────────────────────────────

Set<String> _getOldIcons() {
  final file = File('../lib/src/phosphor_icons_regular.dart');
  if (!file.existsSync()) return {};
  final content = file.readAsStringSync();
  final regex = RegExp(r'static const IconData (\w+) = IconData');
  return regex.allMatches(content).map((m) => m.group(1)!).toSet();
}

void _writeHeader(StringBuffer buf) {
  buf.writeln('// Gerado automaticamente — não edite manualmente.');
  buf.writeln('// Execute: cd tool && dart generate.dart');
  buf.writeln();
}

String _toCamelCase(String name) {
  final parts = name.split(RegExp(r'[-_\s]'));
  if (parts.isEmpty) return name;
  return parts.first +
      parts
          .skip(1)
          .map((p) => p.isEmpty ? '' : p[0].toUpperCase() + p.substring(1))
          .join();
}

String _toKebabCase(String camel) {
  return camel.replaceAllMapped(
    RegExp(r'[A-Z]'),
    (m) => '-${m.group(0)!.toLowerCase()}',
  );
}

class _StyleConfig {
  final String id;
  final String styleName;
  final String fontFileName;
  final String fontFamily;
  const _StyleConfig(this.id, this.styleName, this.fontFileName, this.fontFamily);
}
