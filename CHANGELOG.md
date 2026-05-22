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
