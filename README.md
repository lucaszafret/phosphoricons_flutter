# Phosphor Icons for Flutter

🇧🇷 [Leia este documento em Português](README.pt-BR.md)

[![pub.dev](https://img.shields.io/pub/v/phosphoricons_flutter.svg)](https://pub.dev/packages/phosphoricons_flutter)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Dart 3.x](https://img.shields.io/badge/Dart-3.x-blue.svg)](https://dart.dev)
[![Community Package](https://img.shields.io/badge/Community-Package-blue.svg)](#)

> **⚠️ Unofficial Community Package**  
> This is an unofficial, community-maintained Flutter package. It is not affiliated with or endorsed by the original creators of Phosphor Icons. All icon assets are the property of their respective creators.

A complete Flutter icon library based on [Phosphor Icons](https://phosphoricons.com) — **1530+ icons** in **6 weight styles**, fully compatible with **Dart 3.x**.

> **Why a new package?**  
> The original `phosphor_flutter` uses `class PhosphorIconData extends IconData`, which breaks in Dart 3.x because `IconData` became a `final class`. This package fixes that from the ground up and stays in sync with the official Phosphor Icons core.

---

## Features

- **1530+ icons** from [Phosphor Icons](https://phosphoricons.com) core v2.0.8
- **6 weight styles** — Thin, Light, Regular, Bold, Fill, Duotone
- **Dart 3.x compatible** — no `extends IconData` anywhere
- **Duotone support** via `PhosphorIcon` widget (two-layer Stack with configurable opacity and color)
- **Two access patterns** — per-style classes or single-class shortcuts
- **All icon aliases** included (e.g. `asclepius` and `caduceus` share the same codepoint)
- **Tree-shaking friendly** — all classes are annotated with `@staticIconProvider`
- **Drop-in for existing code** — `PhosphorIconsRegular.xxx` pattern works as before

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  phosphoricons_flutter: ^1.0.0
```

Then run:

```bash
flutter pub get
```

---

## Usage

### 1. Flat styles — Thin, Light, Regular, Bold, Fill

Use with Flutter's built-in `Icon` widget. All constants are plain `IconData`.

```dart
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

// Per-style class (explicit and tree-shakeable)
Icon(PhosphorIconsRegular.storefront, size: 32)
Icon(PhosphorIconsBold.storefront, size: 32)
Icon(PhosphorIconsThin.storefront, size: 32)
Icon(PhosphorIconsLight.storefront, size: 32)
Icon(PhosphorIconsFill.storefront, size: 32, color: Colors.deepPurple)
```

### 2. PhosphorIcons — single-class shortcuts

Access any icon and style through one class with name suffixes:

```dart
Icon(PhosphorIcons.storefront)          // Regular (default)
Icon(PhosphorIcons.storefrontBold)      // Bold
Icon(PhosphorIcons.storefrontFill)      // Fill
Icon(PhosphorIcons.storefrontThin)      // Thin
Icon(PhosphorIcons.storefrontLight)     // Light
PhosphorIcon(PhosphorIcons.storefrontDuotone)  // Duotone
```

### 3. PhosphorIcon widget

`PhosphorIcon` is a drop-in for Flutter's `Icon` widget and automatically handles both flat and Duotone icons:

```dart
PhosphorIcon(PhosphorIconsRegular.house)
PhosphorIcon(PhosphorIconsBold.heart, color: Colors.red, size: 32)
PhosphorIcon(PhosphorIconsFill.rocketLaunch, color: Colors.deepPurple)
```

### 4. Duotone

Duotone icons require `PhosphorIcon` because they render two font layers stacked via a `Stack` widget.

```dart
// Basic — secondary layer at default opacity (0.20)
PhosphorIcon(PhosphorIconsDuotone.storefront)

// Custom color and opacity
PhosphorIcon(
  PhosphorIconsDuotone.storefront,
  size: 48,
  color: Colors.indigo,
  duotoneSecondaryOpacity: 0.30,
)

// Custom secondary color (fill layer gets a different tint)
PhosphorIcon(
  PhosphorIconsDuotone.rocketLaunch,
  color: Colors.white,
  duotoneSecondaryColor: Colors.deepPurple,
  duotoneSecondaryOpacity: 0.40,
)
```

### 5. Finding icon names

All icons use camelCase. Find any icon at [phosphoricons.com](https://phosphoricons.com) and convert:

| Phosphor name | Dart constant |
|---|---|
| `storefront` | `PhosphorIconsRegular.storefront` |
| `rocket-launch` | `PhosphorIconsRegular.rocketLaunch` |
| `graduation-cap` | `PhosphorIconsRegular.graduationCap` |
| `chart-bar` | `PhosphorIconsRegular.chartBar` |
| `magnifying-glass` | `PhosphorIconsRegular.magnifyingGlass` |

---

## API Reference

### PhosphorIcon

| Property | Type | Default | Description |
|---|---|---|---|
| `icon` | `Object` | required | `IconData` or `PhosphorDuotoneIconData` |
| `size` | `double?` | `null` | Size in logical pixels (inherits from `IconTheme`) |
| `color` | `Color?` | `null` | Icon color (inherits from `IconTheme`) |
| `duotoneSecondaryOpacity` | `double` | `0.20` | Opacity of the background fill layer (Duotone only) |
| `duotoneSecondaryColor` | `Color?` | `null` | Color of the fill layer — defaults to `color` |
| `semanticLabel` | `String?` | `null` | Accessibility label |
| `textDirection` | `TextDirection?` | `null` | Text direction override |

### Icon classes

| Class | Style |
|---|---|
| `PhosphorIconsRegular` | Regular weight |
| `PhosphorIconsThin` | Thin weight |
| `PhosphorIconsLight` | Light weight |
| `PhosphorIconsBold` | Bold weight |
| `PhosphorIconsFill` | Filled style |
| `PhosphorIconsDuotone` | Duotone (use with `PhosphorIcon`) |
| `PhosphorIcons` | Shortcut — all styles via name suffix |

### Types

| Type | Description |
|---|---|
| `PhosphorIconData` | Alias for `IconData` (backward compatibility) |
| `PhosphorDuotoneIconData` | Holds two `IconData` (primary fill + secondary strokes) |
| `PhosphorIconsStyle` | Enum: `thin`, `light`, `regular`, `bold`, `fill`, `duotone` |

---

## Dart 3.x Compatibility

The original `phosphor_flutter` package extended `IconData`:

```dart
// phosphor_flutter — breaks in Dart 3.x
class PhosphorIconData extends IconData { ... }
```

Dart 3.x made `IconData` a `final class`, so extending it outside `dart:ui` causes a compile error. This package fixes that:

```dart
// phosphoricons_flutter — Dart 3.x compatible
typedef PhosphorIconData = IconData;  // alias, no inheritance
```

`PhosphorDuotoneIconData` is a standalone class (no `IconData` inheritance) and is handled transparently by the `PhosphorIcon` widget via a `Stack`.

---

## Migrating from phosphor_flutter (v2.x)

If you are migrating an existing project from the deprecated `phosphor_flutter` package, please note the following breaking changes:

### 1. Update Imports
Replace all imports of the old package with the new one:
* **Search:** `import 'package:phosphor_flutter/phosphor_flutter.dart';`
* **Replace with:** `import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';`

*Tip: You can use global "Find & Replace" in your IDE (VS Code, Android Studio, IntelliJ) to update all files at once.*

### 2. Duotone Icons & Type Incompatibility
In the original `phosphor_flutter`, Duotone icons (like `PhosphorIconsDuotone.whatsappLogo`) were subtypes of `IconData`. In `phosphoricons_flutter`, due to Dart 3.x requirements, Duotone icons now use `PhosphorDuotoneIconData` (which does **not** inherit from `IconData`).

* **Widget Usage**: You must render Duotone icons using the `PhosphorIcon` widget. The Flutter standard `Icon` widget will no longer accept Duotone icons.
  ```dart
  // ❌ Will not compile
  Icon(PhosphorIconsDuotone.bell)

  // ✅ Will compile and render properly
  PhosphorIcon(PhosphorIconsDuotone.bell)
  ```

* **Custom Components & Variable Types**: If you pass Duotone icons into custom widgets or store them in variables typed as `IconData?`, you must change their types to `Object?` or `dynamic`:
  ```dart
  // ❌ Will fail when passing a Duotone icon
  class MyButton extends StatelessWidget {
    final IconData? icon;
    const MyButton({this.icon});
    
    @override
    Widget build(BuildContext context) {
      return Icon(icon);
    }
  }

  // ✅ Use Object? and PhosphorIcon
  class MyButton extends StatelessWidget {
    final Object? icon; // Accepts both IconData and PhosphorDuotoneIconData
    const MyButton({this.icon});
    
    @override
    Widget build(BuildContext context) {
      return PhosphorIcon(icon);
    }
  }
  ```

---

## Updating icons

When Phosphor Icons releases new icons:

1. Download the latest font ZIP from [phosphoricons.com](https://phosphoricons.com) → **Download** → **Fonts**
2. Extract and replace the contents of `phosphor-icons/Fonts/` in the repo root
3. Run the generator:

```bash
cd tool
dart pub get
dart generate.dart
```

The generator reads each `selection.json`, copies the TTF files to `lib/fonts/`, and regenerates all 7 Dart source files automatically.

---

## Contributing

Contributions are welcome! Please open an issue or pull request on [GitHub](https://github.com/lucaszafret/phosphoricons_flutter).

If you find an icon that is missing or named incorrectly, it is most likely a data issue in the official Phosphor release — check [phosphor-icons/core](https://github.com/phosphor-icons/core) first, then open an issue here.

---

## License

This package is released under the [MIT License](LICENSE).

The Phosphor Icons font files in `lib/fonts/` are also MIT licensed by [Phosphor Icons](https://github.com/phosphor-icons/core).
