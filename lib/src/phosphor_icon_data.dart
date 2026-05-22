// Dart 3.x tornou IconData uma "final class" — herança externa quebra o build.
// Solução: usamos IconData diretamente como tipo de todas as constantes flat.
// PhosphorDuotoneIconData é uma classe própria, não derivada de IconData.

import 'package:flutter/widgets.dart';

/// Alias for [IconData] maintained for compatibility with code that explicitly
/// references `PhosphorIconData` as a type.
/// 
/// [PT] Alias de [IconData] mantido para compatibilidade com código que
/// referencia explicitamente `PhosphorIconData` como tipo.
typedef PhosphorIconData = IconData;

/// Data of a Phosphor icon in the Duotone style.
///
/// Contains two codepoints: [primary] (fill layer, rendered at reduced opacity
/// in the background) and [secondary] (stroke layer, rendered at full opacity
/// in the foreground).
///
/// Always use with the [PhosphorIcon] widget:
/// ```dart
/// PhosphorIcon(PhosphorIconsDuotone.storefront, color: Colors.indigo)
/// ```
/// 
/// ---
/// 
/// [PT] Dados de um ícone Phosphor no estilo Duotone.
///
/// Contém dois codepoints: [primary] (camada de preenchimento, renderizada
/// em opacidade reduzida ao fundo) e [secondary] (camada de traços,
/// renderizada em opacidade total à frente).
///
/// Use sempre com o widget [PhosphorIcon]:
/// ```dart
/// PhosphorIcon(PhosphorIconsDuotone.storefront, color: Colors.indigo)
/// ```
class PhosphorDuotoneIconData {
  /// Fill/background layer — rendered at reduced opacity.
  /// 
  /// [PT] Camada de preenchimento/fundo — renderizada em opacidade reduzida.
  final IconData primary;

  /// Stroke/foreground layer — rendered at full opacity.
  /// 
  /// [PT] Camada de traços/contorno — renderizada em opacidade total.
  final IconData secondary;

  const PhosphorDuotoneIconData(this.primary, this.secondary);
}

/// Available styles for Phosphor icons.
/// 
/// [PT] Estilos disponíveis dos ícones Phosphor.
enum PhosphorIconsStyle {
  thin,
  light,
  regular,
  bold,
  fill,
  duotone,
}
