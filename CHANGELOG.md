## 1.1.1

* **Icon previews now show in VS Code.** The preview images added to the docs in 1.1.0 were SVGs, and VS Code does not render remote SVGs in hovers (it showed a broken image). They are now small PNGs (48 px, one per constant, 9180 in total) served by jsDelivr and pinned to the release tag. They also work in the pub.dev API docs and in IntelliJ. The PNGs live in `doc/icons/` in the repository and are not part of the published package, so the package size does not change.
* Code, icons and fonts are identical to 1.1.0.

## 1.1.0

* **`shadows` is back** on `PhosphorIcon` (fixes [#1](https://github.com/lucaszafret/phosphoricons_flutter/issues/1)). It works in every style; in Duotone the shadows are applied to both layers, like the original `phosphor_flutter`.
* `PhosphorIcon` also accepts `fill`, `weight`, `grade` and `opticalSize` again, so code migrated from `phosphor_flutter` compiles unchanged. They have no visual effect: Phosphor fonts are static.
* **Documentation**: every icon constant (all six style classes and every `PhosphorIcons` shortcut) now has a bilingual (EN / PT) dartdoc description, and the library is documented.
* **Fixed broken icon previews in the docs**: the preview image of the Thin, Light, Bold and Fill constants (and of alias names such as `caduceus`) pointed to files that do not exist, and the Regular/Duotone ones were drawn huge and black. All 9180 previews now load at 32 px in a neutral grey that is readable on light and dark themes (IDE hover / autocomplete and pub.dev API docs).
* **pub.dev screenshots** added (`screenshots/`, regenerated with `example/test/screenshots_test.dart`).
* **Icons**: no icon changes. The bundled fonts were already Phosphor Icons v2.1.x (identical to `@phosphor-icons/web` 2.1.x); the 1.0.0 docs wrongly said core v2.0.8. Docs corrected.
* Example app: fixed a crash (missing `DefaultTabController`), added a Shadows tab and a widget test that opens every tab.
* The `assert` message of `PhosphorIcon` is now bilingual.
* Repository: added a GitHub Actions workflow (format, analyze, tests, `pub publish --dry-run`) and stopped tracking the `example/build/` artifacts that had been committed by mistake.
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
