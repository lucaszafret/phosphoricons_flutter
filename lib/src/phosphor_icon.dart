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
///
/// // Shadows
/// PhosphorIcon(
///   PhosphorIconsBold.heart,
///   color: Colors.red,
///   shadows: [Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
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

  /// A list of [Shadow]s that will be painted underneath the icon.
  ///
  /// In the Duotone style the shadows are applied to both layers, as in the
  /// original `phosphor_flutter` package. The shadow of the fill layer is
  /// attenuated by [duotoneSecondaryOpacity].
  ///
  /// When `null`, inherits from [IconTheme].
  ///
  /// [PT] Lista de [Shadow]s pintadas atrás do ícone.
  ///
  /// No estilo Duotone as sombras são aplicadas nas duas camadas, como no
  /// pacote original `phosphor_flutter`. A sombra da camada de preenchimento é
  /// atenuada por [duotoneSecondaryOpacity].
  ///
  /// Quando `null`, herda de [IconTheme].
  final List<Shadow>? shadows;

  /// The fill axis value, between 0.0 and 1.0.
  ///
  /// Has no visual effect on Phosphor icons, whose fonts are static (they have
  /// no variable axes). Accepted only for source compatibility with
  /// `phosphor_flutter` and with Flutter's [Icon].
  ///
  /// [PT] Valor do eixo de preenchimento, entre 0.0 e 1.0.
  ///
  /// Não tem efeito visual nos ícones Phosphor, cujas fontes são estáticas
  /// (sem eixos variáveis). Aceito apenas por compatibilidade de código com o
  /// `phosphor_flutter` e com o [Icon] do Flutter.
  final double? fill;

  /// The stroke weight axis value. Must be greater than 0.
  ///
  /// Has no visual effect on Phosphor icons (static fonts). To change the
  /// weight, pick another style, such as `PhosphorIconsBold`. Accepted only for
  /// source compatibility.
  ///
  /// [PT] Valor do eixo de espessura do traço. Deve ser maior que 0.
  ///
  /// Não tem efeito visual nos ícones Phosphor (fontes estáticas). Para mudar a
  /// espessura, escolha outro estilo, como `PhosphorIconsBold`. Aceito apenas
  /// por compatibilidade de código.
  final double? weight;

  /// The grade axis value.
  ///
  /// Has no visual effect on Phosphor icons (static fonts). Accepted only for
  /// source compatibility.
  ///
  /// [PT] Valor do eixo de contraste (grade).
  ///
  /// Não tem efeito visual nos ícones Phosphor (fontes estáticas). Aceito
  /// apenas por compatibilidade de código.
  final double? grade;

  /// The optical size axis value. Must be greater than 0.
  ///
  /// Has no visual effect on Phosphor icons (static fonts). Accepted only for
  /// source compatibility.
  ///
  /// [PT] Valor do eixo de tamanho óptico. Deve ser maior que 0.
  ///
  /// Não tem efeito visual nos ícones Phosphor (fontes estáticas). Aceito
  /// apenas por compatibilidade de código.
  final double? opticalSize;

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

  /// Creates a Phosphor icon widget.
  ///
  /// [PT] Cria um widget de ícone Phosphor.
  const PhosphorIcon(
    this.icon, {
    super.key,
    this.size,
    this.fill,
    this.weight,
    this.grade,
    this.opticalSize,
    this.color,
    this.shadows,
    this.duotoneSecondaryOpacity = 0.20,
    this.duotoneSecondaryColor,
    this.semanticLabel,
    this.textDirection,
  })  : assert(
          icon is IconData || icon is PhosphorDuotoneIconData,
          'icon must be IconData or PhosphorDuotoneIconData. '
          '[PT] icon deve ser IconData ou PhosphorDuotoneIconData.',
        ),
        assert(fill == null || (0.0 <= fill && fill <= 1.0)),
        assert(weight == null || (0.0 < weight)),
        assert(opticalSize == null || (0.0 < opticalSize));

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
              fill: fill,
              weight: weight,
              grade: grade,
              opticalSize: opticalSize,
              color: duotoneSecondaryColor ?? color,
              shadows: shadows,
              textDirection: textDirection,
            ),
          ),
          Icon(
            duotone.secondary,
            size: size,
            fill: fill,
            weight: weight,
            grade: grade,
            opticalSize: opticalSize,
            color: color,
            shadows: shadows,
            semanticLabel: semanticLabel,
            textDirection: textDirection,
          ),
        ],
      );
    }

    return Icon(
      icon as IconData,
      size: size,
      fill: fill,
      weight: weight,
      grade: grade,
      opticalSize: opticalSize,
      color: color,
      shadows: shadows,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    );
  }
}
