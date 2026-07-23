# Changelog

## [0.1.3](https://github.com/Ventairy/mateo/compare/mateo-mobile-flutter-v0.1.2...mateo-mobile-flutter-v0.1.3) (2026-07-23)


### Bug Fixes

* **mateo-mobile-flutter:** align map color scheme test ([db6a907](https://github.com/Ventairy/mateo/commit/db6a907423e8eeac6c1eda0115e179292f6aaa21))
* **mateo-mobile-flutter:** make landuse in map color scheme be same as background ([308c97b](https://github.com/Ventairy/mateo/commit/308c97b88705b5ab453a65f733dbad3518cf92ec))

## [0.1.2](https://github.com/Ventairy/mateo/compare/mateo-mobile-flutter-v0.1.1...mateo-mobile-flutter-v0.1.2) (2026-07-23)


### Bug Fixes

* **mateo-mobile-flutter:** improve readme and remove pubspec lock from source control ([8991464](https://github.com/Ventairy/mateo/commit/899146461a23efb3763aa7ed919f6cd1afe5eb73))

## [0.1.1](https://github.com/Ventairy/mateo/compare/mateo-mobile-flutter-v0.1.0...mateo-mobile-flutter-v0.1.1) (2026-07-23)


### Bug Fixes

* **mateo-mobile-flutter:** correct button quick start ([#8](https://github.com/Ventairy/mateo/issues/8)) ([b731820](https://github.com/Ventairy/mateo/commit/b731820737860db17894e62616b09ba5133adca7))

## 0.1.0 - 2026-07-22

- Add the first Flutter implementation of Mateo Mobile for Android and iOS.
- Add Mateo violet, brand-seed generation, tinted neutrals, vivid fixed scales,
  and the mobile semantic color scheme.
- Expose theme-authored `colors.neutral.solid` and `colors.neutral.onSolid`
  through a reusable color-variant contract.
- Keep each app's `primary` and `onPrimary` colors together so primary surfaces
  use the foreground selected by the consuming package.
- Add application theming, Inter typography, MapLibre style models, and bundled
  SVG assets.
- Keep typography foundations to Inter and fixed `-0.2` letter spacing, with
  font size, weight, and line height owned by each component.
- Add buttons, search, typed toasts, bottom sheets, loading and skeleton states,
  gesture surfaces, Y-Snap Lists, maps, heroes, and motion primitives.
- Add Error, Warning, Info, Success, and Neutral toast statuses with semantic
  colors and status-specific icons.
- Add reduced-motion behavior, semantic labels, text-scaling support, safe-area
  handling, focused tests, and CI goldens.
