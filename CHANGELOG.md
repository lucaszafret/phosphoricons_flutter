## 1.1.0

* **`shadows` is back** on `PhosphorIcon` (fixes [#1](https://github.com/lucaszafret/phosphoricons_flutter/issues/1)). It works in every style; in Duotone the shadows are applied to both layers, like the original `phosphor_flutter`.
* `PhosphorIcon` also accepts `fill`, `weight`, `grade` and `opticalSize` again, so code migrated from `phosphor_flutter` compiles unchanged. They have no visual effect: Phosphor fonts are static.
* **Documentation**: every icon constant (all six style classes and every `PhosphorIcons` shortcut) now has a bilingual (EN / PT) dartdoc description, and the library is documented.
* **Icons**: no icon changes. The bundled fonts were already Phosphor Icons v2.1.x (identical to `@phosphor-icons/web` 2.1.x); the 1.0.0 docs wrongly said core v2.0.8. Docs corrected.
* Example app: fixed a crash (missing `DefaultTabController`) and added a Shadows tab.
* Code is now formatted with the current `dart format` (the check pub.dev runs), and the icon generator formats its own output.
* Tooling: updated for Flutter 3.47.6 and the latest dependencies; icon generator emits the new docs.

## 1.0.0

* Initial release of `phosphoricons_flutter`.
* **Bilingual Support**: Both Portuguese (`pt-BR`) and English documentation (READMEs and inline docstrings).
* **1530+ icons** from [Phosphor Icons](https://phosphoricons.com) core v2.0.8.
* **6 weight styles**: Thin, Light, Regular, Bold, Fill, Duotone.
* **Dart 3.x compatible** — no `extends IconData` (which broke in Dart 3.x as `IconData` became `final`).
* `PhosphorIcon` widget with native Duotone support — two-layer `Stack` with configurable `duotoneSecondaryOpacity` and `duotoneSecondaryColor`.
* `PhosphorIcons` convenience class: `PhosphorIcons.storefront`, `PhosphorIcons.storefrontBold`, `PhosphorIcons.storefrontDuotone`, etc.
* Per-style classes: `PhosphorIconsRegular`, `PhosphorIconsThin`, `PhosphorIconsLight`, `PhosphorIconsBold`, `PhosphorIconsFill`, `PhosphorIconsDuotone`.
* All icon aliases included (e.g. `asclepius` and `caduceus` share the same codepoint).
* `@staticIconProvider` annotation on all icon classes for Flutter tree-shaking.
* Automated icon generator at `tool/generate.dart` for updating icons from official Phosphor font ZIPs.
