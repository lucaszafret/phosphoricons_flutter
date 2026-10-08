# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Comandos principais

```bash
# Instalar dependências
flutter pub get

# Rodar testes
flutter test

# Rodar um teste específico
flutter test test/phosphoricons_flutter_test.dart

# Análise estática
flutter analyze

# Regenerar todos os arquivos de ícones (após atualizar fontes)
cd tool && dart pub get && dart generate.dart
```

## Arquitetura

Este é um pacote Flutter de ícones com **1530+ ícones** em **6 estilos** (Thin, Light, Regular, Bold, Fill, Duotone), baseado no [Phosphor Icons](https://phosphoricons.com) v2.1.x (as fontes e os `selection.json` são idênticos aos do pacote npm `@phosphor-icons/web` 2.1.x).

### Motivação da existência do pacote

O pacote original `phosphor_flutter` estendia `IconData` (`class PhosphorIconData extends IconData`), o que quebra no Dart 3.x porque `IconData` tornou-se `final class`. Este pacote usa `typedef PhosphorIconData = IconData` (alias, sem herança) para compatibilidade.

### Estrutura dos arquivos gerados

Os arquivos em `lib/src/phosphor_icons_*.dart` são **gerados automaticamente** — nunca os edite manualmente. Sempre execute o gerador:

```
lib/src/
  phosphor_icon_data.dart      ← tipos base (PhosphorDuotoneIconData, PhosphorIconData, PhosphorIconsStyle)
  phosphor_icon.dart           ← widget PhosphorIcon (escrito à mão)
  phosphor_icons_regular.dart  ← GERADO
  phosphor_icons_thin.dart     ← GERADO
  phosphor_icons_light.dart    ← GERADO
  phosphor_icons_bold.dart     ← GERADO
  phosphor_icons_fill.dart     ← GERADO
  phosphor_icons_duotone.dart  ← GERADO
  phosphor_icons.dart          ← GERADO (atalhos com sufixo: storefrontBold, storefrontFill, etc.)
```

### Tipos fundamentais

- **Estilos flat** (Thin, Light, Regular, Bold, Fill): constantes `IconData` simples, usadas com `Icon()` do Flutter.
- **Duotone**: constantes `PhosphorDuotoneIconData` com dois codepoints (`primary` = camada de preenchimento/fundo, `secondary` = camada de traços). Requer o widget `PhosphorIcon`.
- **`PhosphorIcon`**: widget drop-in para `Icon` que detecta automaticamente se o ícone é flat ou Duotone. Para Duotone, renderiza um `Stack` com duas camadas, onde a camada primária fica em `duotoneSecondaryOpacity` (padrão 0.20).

### Gerador (`tool/generate.dart`)

Lê `phosphor-icons/Fonts/<estilo>/selection.json` para obter nomes e codepoints, copia os TTFs para `lib/fonts/`, regenera todos os 7 arquivos Dart e roda `dart format` em `lib/src` (o pub.dev reprova código fora do formato). Antes de publicar: `dart format --output=none --set-exit-if-changed lib test example/lib`. Nomes são convertidos de kebab-case para camelCase. Aliases (ex: `asclepius, caduceus`) recebem constantes separadas com o mesmo codepoint.

### Fontes TTF

Registradas no `pubspec.yaml` com famílias nomeadas (`PhosphorRegular`, `PhosphorThin`, `PhosphorLight`, `PhosphorBold`, `PhosphorFill`, `PhosphorDuotone`). Todas as constantes usam `fontPackage: 'phosphoricons_flutter'` para funcionar corretamente quando consumidas por outros pacotes.

## Atualização de ícones

1. Baixar novo ZIP em phosphoricons.com → Download → Fonts (ou usar `src/<estilo>/` do pacote npm `@phosphor-icons/web`, que traz os mesmos `selection.json` e TTFs). Antes de baixar, compare os checksums com os arquivos atuais: se forem iguais, não há nada a atualizar.
2. Substituir o conteúdo de `phosphor-icons/Fonts/`
3. Executar `cd tool && dart generate.dart`
4. Verificar o relatório no terminal e o arquivo gerado `NEW_ICONS.md` (contém o diff de ícones novos/removidos em formato markdown pronto para colar no CHANGELOG).

## Imagens de pré-visualização nas docstrings

Cada constante gerada tem `![nome](https://cdn.jsdelivr.net/gh/lucaszafret/phosphoricons_flutter@v<versão>/doc/icons/<estilo>/<nome-kebab>.png)`.

- **PNG, não SVG**: o VS Code NÃO renderiza SVG remoto no hover (testado: Iconify, com e sem parâmetros, aparece como imagem quebrada), mas renderiza PNG remoto (testado: GitHub raw e jsDelivr). Os SVGs crus do Phosphor também não têm width/height e apareceriam gigantes.
- Os PNGs (48 px, cinza #888, gray+alpha, ~570 bytes) ficam em `doc/icons/` (versionados, ~5 MB) e são gerados com as próprias fontes por `example/test/doc_icons_test.dart`: `cd example && GENERATE_DOC_ICONS=1 flutter test test/doc_icons_test.dart`. Há um arquivo por constante (aliases inclusos), então o gerador não precisa mapear aliases.
- A URL é fixada na tag `v<versão do pubspec.yaml>` (lida em `_docImageUrl`, no gerador). **Crie a tag `v<versão>` e dê push nela ANTES de `flutter pub publish`**, senão as imagens só aparecem depois.
- `doc/` está no `.pubignore`: não vai para o pacote publicado. Confirme no `flutter pub publish --dry-run`.
- Ao atualizar ícones: rode o gerador (`tool/`), depois o teste dos PNGs, e confira que cada URL dos `///` aponta para um arquivo de `doc/icons/`.
- As bolinhas de ícone ao lado do código no VS Code são um recurso fixo da extensão Dart só para `Icons.*` e `CupertinoIcons.*`: nenhum pacote consegue ativá-las; o que funciona é o hover/autocomplete com essa imagem.

## Screenshots do pub.dev

`screenshots/*.png` (listadas em `screenshots:` no `pubspec.yaml`) são geradas por `example/test/screenshots_test.dart`:
`cd example && GENERATE_SCREENSHOTS=1 flutter test --update-goldens test/screenshots_test.dart`. Máx. 10 imagens, 4 MB cada, descrição ≤ 160 caracteres; a primeira vira a miniatura. Não use logos.

## CI

`.github/workflows/ci.yml` roda formatação, analyze, testes (pacote e exemplo) e `flutter pub publish --dry-run`.

## Internacionalização (Suporte Bilíngue)

O pacote é construído com suporte a duas linguagens (Inglês como primário, e Português `[PT]`).
- O `README` possui duas versões (`README.md` e `README.pt-BR.md`).
- O gerador (`tool/generate.dart`) automaticamente embute docstrings nos dois idiomas para todas as constantes geradas (as 6 classes de estilo e os atalhos de `PhosphorIcons`, +18000), garantindo que o "Hover" da IDE seja bilíngue e que o pub.dev conte a documentação da API (mínimo de 20%).
