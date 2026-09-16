# AGENTS.md — Mateo

## Purpose

This is the Mateo mobile implementation for flutter. Mateo is a simple, expressive, warm design system for software that feels obvious, kind, tactile, and human.

## File Organization

- Reserve `lib/src/components/` for components backed by Mateo design-system
  guidance.
- Place Flutter infrastructure widgets, such as `MateoApp`, under
  `lib/src/widgets/<widget_name>/`.

### Foundation And Contextual Ownership

- Reserve `lib/src/foundation/` for foundational classes, enums, and
  configuration contracts shared across multiple components or bases. Do not
  place a type there merely because it is public or might be reused later.
- Foundation must not own rendering widgets, inherited interaction scopes,
  or component-specific layout and lifecycle implementation. Keep those files
  with the component or base that owns their behavior.
- Group contextual supporting files under their owner, including configuration
  classes, presentation renderers, and row widgets. For example, `MateoMenu`
  owns its menu animation, density, presentation, and option item types under
  `components/mateo_menu/`; its options renderers belong under
  `presentations/options_presentation/`, and its private interaction scope
  lives alongside the component.
- A type shared by a component and its composing controls can remain with that
  component. Do not introduce a base or move types into foundation without a
  concrete need for ownership outside that component.
- Keep shared configuration separate from its rendering implementation:
  consumers and bases use the same foundation contract, while the rendering
  owner interprets it.

## Dart Documentation Naming

Use `mateo_mobile` only when referring specifically to the Dart package, its
import path, or its release identity. Do not introduce another design-system
name for the mobile package: this package is the Flutter implementation of
Mateo Mobile.

## Closed Mateo Ecosystem

Treat `mateo_mobile` as a complete, opinionated design-system package for
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

- Configure `AlchemistConfig` in `test/flutter_test_config.dart`. Wrap themed
  golden scenarios in `MateoTheme(data: MateoThemeData.light(accentColor: ...,
onAccent: ...), child: ...)`; no Material theme is needed by Mateo.
- Regenerate approved theme goldens from this package with
  `fvm flutter test --update-goldens test/widgets/mateo_theme_golden_test.dart`.
- Resolve test colors from the same `MateoThemeData` applied by the test. Use
  its color scheme when the target consumes semantic colors, and use its
  palette only when the target consumes palette primitives. Fixed colors are
  allowed only when the exact color value is the contract under test, such as
  palette anchors, custom seeds, alpha validation, or color interpolation.
- Use the shared test theme for default widget and golden scenarios. A test
  with a custom theme must derive its expected colors from that exact theme.
  Golden changes remain the visual signal for intentional color-scheme edits.

## Releases

Follow [RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md) for all release rules and
verification steps.
