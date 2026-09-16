# AGENTS.md — Mateo

## Purpose

Mateo is a simple, expressive, warm design system for software that feels
obvious, kind, tactile, and human.

Mateo Mobile adapts the system for touch-first Android and iOS applications.
The package must remain self-contained for consumers with no access to any
Ventairy product, service, configuration, or private asset. Web and desktop are
not supported product targets.

## Standalone environment

- Clone `oh_my_flutter` beside this repository and use the ignored package
  override files for local development.
- Run `make check` before pull requests and `make pana` for publication changes.

## Closed Mateo Ecosystem

Treat the package as a complete, opinionated design-system package for
Flutter mobile applications. It must be self-contained for consumers and must
not depend on interoperability with Material or another component system.

### Ecosystem rules

- A consumer must not need to import Material, use `MaterialApp`, provide
  `ThemeData`, add Material wrappers, or install another component library to
  use Mateo correctly. Mateo must provide the app, theme, surface, interaction,
  feedback, and accessibility infrastructure its components require.
- Do not expose Material component types, theme types, tokens, variants, or
  terminology through Mateo's public APIs. If an internal use of Flutter's
  Material library is unavoidable, fully encapsulate it so consumer setup and
  component behavior remain Mateo-owned.
- Design components to work together inside the Mateo ecosystem. Prefer strong
  Mateo defaults and a small set of intentional semantic variants over generic
  interoperability hooks, broad styling flexibility, or compatibility with
  arbitrary component systems.
- Do not add escape hatches merely so consumers can reproduce a different
  design system. Add configuration only when it represents a supported Mateo
  decision, required application content, accessibility, localization, or a
  genuine external-system contract.
- Keep genuine external capabilities explicit when Mateo cannot own them. For
  example, a map component may accept tile-provider capability bounds, but it
  must still own its Mateo presentation and must not expose the provider's UI
  system as a styling surface.
- Do not hardcode product-only URLs, signed tokens, backend assumptions, private
  assets, or environment-specific operational details in reusable components.
- Support Android and iOS through native-feeling Mateo behavior. Do not expand
  web or desktop behavior unless the package scope changes explicitly;
  incidental compilation is not a compatibility guarantee.

## Golden Testing

Name each widget's golden test file
`test/widgets/<widget_name>_golden_test.dart`.

### Golden test rules

- Configure `AlchemistConfig` in `test/flutter_test_config.dart` with the
  `lightTheme` from `MateoTheme.light(accentColor: ..., onAccent: ...)` so
  theme tokens resolve in all golden scenarios.
- Regenerate approved goldens from the repository root with
  `make update-goldens`.
- Resolve test colors from the same `MateoThemeData` applied by the test. Use
  its color scheme when the target consumes semantic colors, and use its
  palette only when the target consumes palette primitives. Fixed colors are
  allowed only when the exact color value is the contract under test, such as
  palette anchors, custom seeds, alpha validation, or color interpolation.
- Use the shared test theme for default widget and golden scenarios. A test
  with a custom theme must derive its expected colors from that exact theme.
  Golden changes remain the visual signal for intentional color-scheme edits.

## Conventions

- Access bundled SVG icons via `MateoIcon` (e.g. `MateoIcon.cross(width: 16, height: 16, color: Colors.red)`),
  exported from the barrel. `MateoIcon` is an `abstract final class` with one `static Widget` method per icon,
  delegating to dotdart's generated `$Icons` namespace. Add an `.svg` to `assets/icons/` and run
  `make gen` to generate the dotdart accessor, then add a static method to `MateoIcon`.
  Do not import `src/gen/icons.g.dart` directly from widget code; use `MateoIcon`.
