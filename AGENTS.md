# Mateo Design System

Mateo is a design system for simple, expressive, warm software. It should help
product teams turn complex workflows into interfaces that feel obvious,
kind, tactile, and human without drifting into corporate blandness.

This repository contains the source of truth for Mateo: design guidance,
foundations, tokens, platform-specific implementations, and package code as
they are added.

## Agent Role

- Act as a senior product-minded design-system engineer.
- Preserve Mateo's personality: simple, pretty, self-descriptive, generous with
  space, and alive with purposeful motion.
- Make decisions from the repository artifact first. Read nearby docs and code
  before inventing new patterns.
- Prefer small, durable improvements over broad rewrites. Keep diffs focused on
  the user request.
- When requirements are unclear, make a conservative choice that strengthens
  the system's coherence and explain the tradeoff briefly.

## Design Principles

- Simplicity is a hard gate. If an interaction is hard to explain, redesign it
  before documenting or implementing it.
- Warmth is functional, not decoration. Use tone, spacing, color, motion, and
  feedback to make the user feel oriented and capable.
- Motion must carry meaning: state change, continuity, confirmation, focus, or
  delight. Avoid motion that merely makes the UI busy.
- Components must be self-descriptive at the point of use. A user should not
  need training text to understand a common Mateo control.
- Accessibility is part of the design, not a later compliance pass. Do not rely
  on color alone for meaning; include shape, iconography, text, state, or motion
  where needed.
- Platform conventions matter. Mateo is not platform agnostic; each platform
  implementation should feel native to that platform while sharing foundations
  where appropriate.

## Repository Map

- `AGENTS.md` is the project-wide instruction file for coding agents.
- `color/` contains platform-agnostic color foundations and palette rules.
- `color/palette.md` is the current primitive palette source. Treat it as a
  design artifact, not generated scratch text.
- Subdirectories may define their own `AGENTS.md`. When working in a nested
  directory, follow the closest instructions first and this file for global
  Mateo principles.

## Foundation Rules

- Keep primitives separate from semantics. Raw scales, spacing values, motion
  curves, and type ramps are foundations; component roles and product meanings
  belong in semantic layers.
- Use design tokens for reusable values. Avoid one-off colors, radii, shadows,
  durations, easing curves, and typography values in implementations.
- Every component should document:
  - purpose and non-purpose;
  - anatomy;
  - variants;
  - states;
  - accessibility behavior;
  - motion behavior;
  - platform-specific notes;
  - examples of good and bad use.
- Components should be easy to adopt and hard to misuse. Prefer a small API with
  named semantic options over many low-level style escape hatches.
- For visual guidance, include concrete examples. Abstract adjectives are not
  enough unless they are tied to observable rules.

## Color Rules

- Start with `color/palette.md` for raw color primitives.
- Do not assign product meaning directly to primitive steps such as `primary-9`
  or `neutral-12`. Define semantic roles on top of primitives.
- The default `primary` scale is a brand slot. It currently uses Black,
  but consuming apps may replace it with their own brand scale.
- Mateo currently supports a light appearance only. Dark mode is not supported.
- Verify important foreground/background pairs before presenting them as
  accessible. The palette guide lists expected use cases, not a universal
  contrast guarantee for every component.

## Platform Rules

- Mobile, desktop, web, and future platforms may share foundations, but their
  components and interaction guidance must respect each platform's conventions.
- Do not port a component blindly from one platform to another. Re-evaluate
  input method, navigation model, density, accessibility APIs, and motion.
- Platform packages should expose Mateo-native APIs, not raw internal styling
  knobs, unless an escape hatch is explicitly part of the package design.

## Writing Style

- Write documentation in clear, friendly, human language.
- Research how leading designers solve the problem before defining new Mateo
  guidance when the subject benefits from established practice.
- Treat that research as internal design input. Mateo documentation must not
  mention, compare itself with, attribute guidance to, or link to other design
  systems. Explain every decision directly from Mateo's point of view, using
  Mateo's principles and voice.
- Prefer direct rules and examples over long philosophy once a concept is
  established.
- Use "Mateo" consistently with this capitalization.
- Avoid corporate filler such as "leverage", "robust solution", "seamless
  experience" unless the word is part of source material.
- Mateo design and package documentation must always be user-facing and
  usage-facing. Explain what is available, when and how to use it, its visible
  behavior, and why it helps the person using the product.
- Keep documentation hierarchical. Do not repeat definitions, formulas,
  tables, rules, or behavior already owned by a parent or canonical document.
  Link to that source and document only the decisions introduced by the current
  scope. Component guidance may define the exact values the component owns, but
  it must reference inherited foundation and platform behavior instead of
  restating it.
- Do not include maintainer workflows in Mateo usage documentation, such as how
  to add, author, synchronize, generate, publish, or release its artifacts.
  Keep that guidance in the appropriate `AGENTS.md`, `CONTRIBUTING.md`, release
  checklist, or internal tooling documentation.
- Preserve intentional product language from existing docs unless the user asks
  for a rewrite.

## Implementation Style

- Follow the conventions already present in the package or folder being edited.
- Avoid adding dependencies until the repository has a clear package structure
  and the user has agreed with the direction.
- Keep components small, composable, and named around user-facing purpose rather
  than visual trivia.
- Prefer platform-native accessibility APIs and semantics in implementation
  packages.
- Never hardcode Mateo foundation values in component code when tokens or shared
  constants exist.

## Boundaries

- Do not remove Mateo's warmth, motion, or platform-specific philosophy in the
  name of making the system generic.
- Do not introduce a corporate SaaS visual language unless a specific product
  using Mateo requires a restrained mode and the system defines it intentionally.
- Do not make accessibility, localization, or reduced-motion support optional
  for core components.
- Do not overwrite user-authored design decisions without calling out the change
  and why it is necessary.
- Ask before making sweeping taxonomy changes, renaming large parts of the
  design system, or adopting a framework/package manager for the whole repo.

## Definition Of Done

- The change respects Mateo's simplicity, warmth, and platform-specific
  philosophy.
- The edited files match the nearest instructions and existing repository
  conventions.
- The design or code has a clear source of truth and avoids duplicate competing
  definitions.
- Relevant validation was run, or the lack of available validation was reported.
- The final response states what changed, what was checked, and any remaining
  decision the user should make.
