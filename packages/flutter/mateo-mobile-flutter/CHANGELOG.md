## 0.1.1

- Remove code of conduct to prioritize the root one
- Improve makefile commands
- Improve contribuiting file
- Remove pubspec override example
- Add pubcpec.lock in gitignore
- Improve readme
- Remove stale content from release checklist
- Remove local docs in favor of real design system docs

## 0.1.0

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
