# Changelog

## [0.2.0](https://github.com/Ventairy/mateo/compare/mateo-mobile-flutter-v0.1.3...mateo-mobile-flutter-v0.2.0) (2026-08-05)


### Features

* **mateo-mobile-flutter:** add custom transitions ([dab5262](https://github.com/Ventairy/mateo/commit/dab52625b496c4463ca6c0e0af9672ff25dfd69d))
* **mateo-mobile-flutter:** implement action bloom for mateo buttons ([d8ccfe0](https://github.com/Ventairy/mateo/commit/d8ccfe0af35e8e5993cd9fd6a2ec3990bf9eb9f7))
* **mateo:** add arrow down icon ([b78a887](https://github.com/Ventairy/mateo/commit/b78a8873feabf247063a87b49bc14bb3bf059bc9))
* **mateo:** add arrow rigth and edit icon ([6284e24](https://github.com/Ventairy/mateo/commit/6284e24b141e1d1983dd4035b488d3d36e9aa23c))
* **mateo:** add plus signal to icons ([2f6bbff](https://github.com/Ventairy/mateo/commit/2f6bbff79518d64457105f1f65edfd94ecff64b1))
* **mateo:** add questionmark icon ([101c5fe](https://github.com/Ventairy/mateo/commit/101c5fee852505fd5d891a628c0ec1edd6de7a44))
* **mateo:** create button panel to place many buttons together in a floating surface ([a719cca](https://github.com/Ventairy/mateo/commit/a719cca2e3a570c976f6f3cf7e1a8257c1b7ef88))


### Bug Fixes

* **mateo-mobile-flutter:** stabilize floating button golden ([531bcd0](https://github.com/Ventairy/mateo/commit/531bcd0be1965a950eff4b3a676867daafbbccd8))
* **mateo-mobile-flutter:** use 15px for font size ([41a88f0](https://github.com/Ventairy/mateo/commit/41a88f091a50f76785cfd5b11464bf7c3f9ffbeb))
* **mateo:** make tertiary text color differentiate more from the secondary ([fdefdf8](https://github.com/Ventairy/mateo/commit/fdefdf8e0c8869c03a3da81f4d27a85374bf8dc1))

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
