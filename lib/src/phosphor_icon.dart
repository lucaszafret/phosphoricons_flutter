import 'package:flutter/widgets.dart';
import 'phosphor_icon_data.dart';

/// Widget that renders Phosphor icons in any style, including Duotone.
///
/// Accepts [IconData] (Thin, Light, Regular, Bold, Fill styles) or
/// [PhosphorDuotoneIconData] (Duotone style). The correct type is returned
/// automatically by the package's constant classes.
///
/// ## Examples
///
/// ```dart
/// // Flat styles — accepts standard Flutter IconData
/// PhosphorIcon(PhosphorIconsRegular.storefront)
/// PhosphorIcon(PhosphorIconsBold.heart, color: Colors.red, size: 32)
///
/// // Shortcut via PhosphorIcons
/// PhosphorIcon(PhosphorIcons.storefrontFill, color: Colors.deepPurple)
///
/// // Duotone — two layers with configurable opacity
/// PhosphorIcon(
///   PhosphorIconsDuotone.storefront,
///   color: Colors.indigo,
///   duotoneSecondaryOpacity: 0.25,
/// )
/// ```
/// 
/// ---
/// 
/// [PT] Widget que renderiza ícones Phosphor em qualquer estilo, incluindo Duotone.
///
/// Aceita [IconData] (estilos Thin, Light, Regular, Bold, Fill) ou
/// [PhosphorDuotoneIconData] (estilo Duotone). O tipo correto é retornado
/// automaticamente pelas classes de constantes do pacote.
class PhosphorIcon extends StatelessWidget {
  /// The icon to render. Must be [IconData] or [PhosphorDuotoneIconData].
  /// 
  /// [PT] O ícone a ser renderizado. Deve ser [IconData] ou [PhosphorDuotoneIconData].
  final Object icon;

  /// Icon size in logical pixels. Inherits from [IconTheme] if not provided.
  /// 
  /// [PT] Tamanho do ícone em pixels lógicos. Herda de [IconTheme] se não informado.
  final double? size;

  /// Icon color. Inherits from [IconTheme] if not provided.
  /// 
  /// [PT] Cor do ícone. Herda de [IconTheme] se não informada.
  final Color? color;

  /// Opacity of the fill layer in the Duotone style.
  ///
  /// Only has effect when [icon] is [PhosphorDuotoneIconData].
  /// Value between 0.0 and 1.0 — default: 0.20.
  /// 
  /// [PT] Opacidade da camada de preenchimento no estilo Duotone.
  ///
  /// Só tem efeito quando [icon] é [PhosphorDuotoneIconData].
  /// Valor entre 0.0 e 1.0 — padrão: 0.20.
  final double duotoneSecondaryOpacity;

  /// Color of the fill layer in the Duotone style.
  ///
  /// When `null`, uses the same color as [color].
  /// 
  /// [PT] Cor da camada de preenchimento no estilo Duotone.
  ///
  /// Quando `null`, usa a mesma cor que [color].
  final Color? duotoneSecondaryColor;

  /// Semantic label for accessibility.
  /// 
  /// [PT] Rótulo semântico para acessibilidade.
  final String? semanticLabel;

  /// Text direction. Overrides the direction inherited from the context.
  /// 
  /// [PT] Direção do texto. Substitui a direção herdada do contexto.
  final TextDirection? textDirection;

  const PhosphorIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.duotoneSecondaryOpacity = 0.20,
    this.duotoneSecondaryColor,
    this.semanticLabel,
    this.textDirection,
  }) : assert(
          icon is IconData || icon is PhosphorDuotoneIconData,
          'icon deve ser IconData ou PhosphorDuotoneIconData',
        );

  @override
  Widget build(BuildContext context) {
    if (icon is PhosphorDuotoneIconData) {
      final duotone = icon as PhosphorDuotoneIconData;
      // primary = codes[0] = camada de preenchimento/fundo (opacidade reduzida)
      // secondary = codes[1] = camada de traços/linhas (opacidade total)
      return Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: duotoneSecondaryOpacity,
            child: Icon(
              duotone.primary,
              size: size,
              color: duotoneSecondaryColor ?? color,
              textDirection: textDirection,
            ),
          ),
          Icon(
            duotone.secondary,
            size: size,
            color: color,
            semanticLabel: semanticLabel,
            textDirection: textDirection,
          ),
        ],
      );
    }

    return Icon(
      icon as IconData,
      size: size,
      color: color,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    );
  }
}
