# Mateo Mobile Design System

This directory is the source of truth for Mateo on mobile. It contains
everything that exists specifically for mobile platforms and nothing intended
to be platform-agnostic, web-only, or desktop-only.

The repository-level `AGENTS.md` still applies. These instructions take
precedence for every file under `design-system/mobile/`.

## Scope

In this directory, **mobile means phones only**. Tablets and
tablet-sized layouts are outside this design-system scope. Do not add tablet
guidance, adaptations, examples, or validation requirements to mobile
documentation or components.

Keep mobile-only work here, including:

- semantic color schemes and authored appearances for mobile;
- mobile components, patterns, navigation, gestures, and touch behavior;
- mobile layout, orientation, safe-area, keyboard, and system-UI behavior;
- mobile typography, iconography, motion, haptics, and feedback;
- iOS- and Android-specific guidance, tokens, assets, and implementations;
- mobile accessibility, localization, performance, and platform integration;
- mobile component examples and adoption guidance.

Do not place platform-agnostic primitives here. Shared color scales, spacing,
type ramps, motion curves, and other reusable foundations belong in
`design-system/foundation/`. Web-only and desktop-only decisions belong in
their respective platform directories.

## Source Of Truth

- Consume raw primitives from `../foundation/`; do not duplicate or fork them
  inside the mobile layer.
- Define mobile semantic roles in this directory. For color, the primitive
  source is `../foundation/color-palette.md` and the mobile mapping belongs in
  `color-scheme.md`.
- Keep product-specific branding outside Mateo unless the artifact explicitly
  documents how a consuming mobile product overrides a Mateo slot.
- If a decision is genuinely reusable across platforms, move it to the
  foundation layer instead of defining competing mobile and shared versions.

## Design Documentation Language

Documents under this directory describe Mateo's observable mobile design
contract, not the code used to produce it.

- Never mention programming frameworks, packages, source files, classes,
  widgets, constructors, methods, properties, callbacks, futures, render
  objects, lifecycle states, or implementation-specific APIs in design
  documentation.
- Do not copy identifiers from an existing implementation into a design
  artifact. Translate them into visible shape, layout, motion, interaction,
  content, state, and accessibility behavior.
- Describe platform capabilities in human terms, such as the system back
  action, safe area, software keyboard, screen reader, or reduced-motion
  setting. Do not name the API that exposes the capability.
- Design token names, platform names, measurable values, formulas, and
  accessibility roles are part of the design contract and may be named
  directly.
- Keep exact framework mappings and coding guidance in the corresponding
  implementation package documentation. They never belong in Mateo usage or
  component design documents.

Abstraction must not make a specification vague. Continue to define every
observable value and transition precisely enough for independent
implementations to reproduce the same Mateo result.

Write each design document so that any designer, engineer, or coding agent can
use it without access to the current implementation and still:

- understand when to use the pattern and when not to use it;
- reproduce the same visible behavior, interaction, states, motion, layout,
  content, and accessibility experience; and
- make the same decisions in cases such as interruption, overflow,
  localization, and platform differences.

A document is not complete if hidden implementation knowledge is required to
use it correctly, or if two reasonable readers could produce materially
different Mateo experiences from its guidance.

## Mobile Design Rules

- Treat iOS and Android as related mobile platforms, not interchangeable
  skins. Share foundations where appropriate and author separate behavior when
  navigation, input, accessibility, system chrome, or motion conventions differ.
- Design for touch first. Interactive targets, gestures, feedback, interruption,
  and one-handed reach must be considered from the start.
- Support mobile devices in portrait and landscape, safe areas, software
  keyboards, dynamic text, localization, screen readers, reduced motion, and
  platform accessibility settings.
- Implement mobile accessibility through each platform's native capabilities.
- Keep public component options Mateo-native and difficult to misuse. Prefer a
  named mobile semantic option over low-level visual overrides.
- Motion and haptics must communicate continuity, state, focus, or confirmation.
  Respect reduced-motion and platform feedback settings.
- Preserve Mateo's warmth and expressiveness without overriding familiar mobile
  affordances merely for visual novelty.

## Working In This Directory

- Read the foundation artifact and the nearest mobile document before changing
  a token, scheme, component, or implementation.
- Keep documentation and implementation aligned; neither may silently create a
  second definition of the same mobile decision.
- Place examples beside the mobile artifact they explain and make platform
  differences explicit.
- Do not introduce a mobile framework, package manager, or dependency until the
  repository defines that implementation direction.
- Keep format, analysis, test, build, and other coding workflows in the
  implementation package's `AGENTS.md`, `CONTRIBUTING.md`, or internal tooling
  documentation. Never place them in mobile design documents.

## Validation

- Check Markdown structure, links, token names, and references for documentation
  changes.
- Verify every mobile semantic color pair in each authored appearance; primitive
  palette membership is not an accessibility guarantee.
- For implementation changes, run the closest package's formatter, analyzer or
  linter, focused tests, accessibility checks, and relevant platform build.
- Test platform-specific behavior on the affected iOS or Android target. Do not
  claim hardware, perceptual, or cross-platform validation that was not run.

## Definition Of Done

- The change is mobile-specific and belongs in this directory.
- Shared primitives remain owned by `design-system/foundation/`.
- iOS and Android differences are explicit where they affect behavior.
- Accessibility, localization, reduced motion, and supported mobile device
  layouts are accounted for.
- Documentation, tokens, examples, and implementation have one clear source of
  truth.
- Relevant validation was run, or the remaining validation boundary was
  reported.
