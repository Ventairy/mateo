# Mateo Public Packages

This directory contains the public library implementations of the Mateo Design
System. Packages here turn Mateo's foundations and platform design guidance into
reusable APIs that product teams can install and use in their applications.

The repository-level `AGENTS.md` still applies. These instructions take
precedence for every file under `packages/` unless a deeper `AGENTS.md` provides
more specific package guidance.

## Scope

Keep publishable design-system implementations here, including:

- platform and framework packages;
- public components, themes, tokens, utilities, and accessibility behavior;
- package documentation, examples, tests, assets, and generated API references;
- compatibility layers and migration support required by released packages;
- metadata and automation needed to analyze, build, version, and publish each
  public library.

Do not place design specifications or platform guidance here. The authored
design system belongs in `design-system/`; `packages/` contains its public
implementations. Product-specific application code, private integrations, and
consumer branding also belong outside this directory.

## Directory Ownership

- Group implementations by language ecosystem: `dart/` and `typescript/`.
- Each ecosystem directory owns its workspace tooling and shared lockfile.
- Name platform package directories `mateo-<platform>-<framework>`; use
  `mateo-<domain>` for framework-independent foundations. Each is a package root.
- TypeScript public package names use the `@mateo` scope, such as
  `@mateo/web-react` and `@mateo/icons`.
- Give each publishable library its own package directory, manifest, tests,
  documentation, changelog, license metadata, and validation commands.
- `dart/mateo-mobile-flutter/` owns the current `mateo_mobile` implementation for Flutter.
- `typescript/mateo-web-react/` owns the `@mateo/web-react` scaffold.
- Add a nested `AGENTS.md` when an ecosystem or package needs instructions that
  do not apply to every public Mateo library.

## Source Of Truth

- Implement foundations from `../design-system/foundation/` rather than copying
  or independently redefining them.
- Implement platform behavior from the matching directory under
  `../design-system/`, such as `../design-system/mobile/` for mobile packages.
- When implementation reveals a missing design decision, update or propose the
  design-system artifact first. Do not let package code silently become a
  competing specification.
- Generated files must identify their source and generation workflow. Never
  hand-edit generated output when the source artifact or generator owns it.

## Public Library Contract

- Treat every exported symbol as a consumer-facing commitment. Keep public APIs
  small, semantic, documented, and difficult to misuse.
- Name APIs around Mateo concepts and user-facing purpose, not internal layout
  or rendering details.
- Keep shared components consistent in user-facing purpose, anatomy, variants,
  states, accessibility, and Mateo character wherever they belong. Consistency
  does not require identical APIs or implementations across ecosystems.
- Design every package API to feel native to its language, UI framework, and
  platform. Use the ecosystem's established types, composition patterns,
  lifecycle, navigation, input, and accessibility conventions.
- Do not add wrappers, abstractions, emulation, or workarounds solely to make one
  package match another package's API or feature set. Prefer a direct native
  implementation, even when its public shape differs.
- Treat framework-specific foundations and integration components as local to
  that framework. Re-evaluate whether each concept belongs before porting it;
  existence in one package is not a requirement for another. For example,
  Flutter's `MateoPage` may remain Flutter-only when its page-transition role is
  already handled natively by SwiftUI or UIKit.
- When a shared component conflicts with platform conventions, preserve its
  Mateo purpose and character while adapting the interaction and API to feel
  native on that platform.
- Do not expose raw styling knobs when a stable semantic option can express the
  supported design decision.
- Preserve native platform conventions, accessibility APIs, localization,
  reduced-motion behavior, and input methods in each implementation.
- Avoid product-specific assumptions, branding, analytics, networking, or
  application state in public packages.
- Minimize dependencies and keep them appropriate for a reusable public
  library. A dependency must provide clear value that cannot be maintained more
  safely within the package.
- Follow semantic versioning once a package is released. Document breaking
  changes, provide migration guidance, and deprecate before removal when
  compatibility permits.

## Package Documentation

### Documentation before publication

For every Mateo package that has not been published, do not add a README,
changelog, or new Mateo design-system documentation for package changes unless
explicitly requested. Defer these artifacts until preparation for real
publication to npm, pub.dev, or another distribution channel. This temporary
rule overrides repository and package documentation requirements, including
requirements in nested instruction files.

Continue reading and following existing Mateo foundations. Agree on component
contracts before implementation, and keep public API behavior clear through
types, focused code comments, and tests. Preserve existing documentation.
Publication preparation must add the consumer documentation, changelog, and
applicable Mateo design guidance. Published packages continue maintaining them.

### Documentation for publication

When preparing for publication, every package should explain:

- what part of Mateo it implements;
- supported platforms and toolchain versions;
- installation and a minimal working example;
- public components and semantic customization points;
- accessibility, localization, and reduced-motion behavior;
- compatibility, versioning, and migration expectations.

Keep documentation consumer-first. A person adopting Mateo should not need to
read repository internals to use the public library correctly.

When package documentation or API documentation references a Mateo design
artifact, link directly to its GitHub URL so the reference works outside a
repository checkout. For example, use
[`color-scheme.md`](https://github.com/Ventairy/mateo/blob/main/design-system/mobile/color-scheme.md)
instead of an unlinked or italicized repository path such as
`design-system/mobile/color-scheme.md`.

## Development And Validation

### Test Selection And Depth

- Test deeply where failure would affect a person using Mateo. Prioritize
  visible regressions in layout, colors, content, overflow, and motion, along
  with interaction, accessibility, state transitions, and supported
  customization. Nonvisual public contracts still deserve coverage when their
  failure would break real consumer usage.
- Evaluate each proposed test by the behavior it protects and the realistic
  regression it would catch. Choose ordinary use, meaningful alternatives, and
  relevant boundary or failure cases; do not add tests merely to increase
  coverage or exercise every internal branch.
- Assert observable outcomes through public APIs. Avoid private helper details,
  internal call sequences, assertions that mirror implementation calculations,
  and tooling behavior such as IDE autocomplete unless a specific regression
  makes that coverage worthwhile.
- Add regression tests in the scope that owns the fix. Do not repeat them in
  every consuming component solely because it uses the corrected behavior.
  Add consumer coverage when it protects a distinct consumer requirement.
- Use visual or golden tests for meaningful appearance contracts and supported
  visual states. They complement behavior and unit tests; they do not replace
  interaction or accessibility assertions. Review baseline changes against the
  authored design before accepting them.
- Resolve expected colors from the exact theme applied by the test: semantic
  roles for semantic consumers, palette values for primitive consumers. Use a
  shared test theme for default scenarios. Fixed colors are appropriate only
  when the exact value is the contract, such as palette anchors, custom seeds,
  alpha validation, or color interpolation.

### Tests As Behavior Documentation

- Write tests as executable documentation. Someone reading the descriptions,
  setup, actions, and assertions should understand how the component or code
  behaves without first reading its implementation.
- State the concrete condition and observable result; avoid vague
  descriptions such as `renders correctly`. Name parameterized cases by their
  meaning rather than opaque numbers. The failure report should explain which
  behavior broke.
- Keep setup and assertions readable and focused. Use descriptive fixtures and
  helpers that reduce repetition without hiding the scenario or its outcome.
- Update descriptions and expectations together when behavior changes. Do not
  leave a passing test describing an outdated rule.

### Validation Workflow

- Follow the manifest, formatter, analyzer or linter, test runner, and build
  tools defined by the package being changed.
- Do not invent repository-wide package commands before the corresponding
  ecosystem configuration exists. Record exact commands in the nearest
  `AGENTS.md` when tooling is introduced.
- Validate examples as real external consumers so they do not depend on private
  repository imports or unpublished implementation details.
- Run focused package checks first, then the broader ecosystem or workspace
  checks defined by the repository.
- Do not claim publication, device, perceptual, or platform validation that was
  not actually completed.

## Definition Of Done

- The implementation traces to a foundation or platform design-system source.
- The public API is intentional, documented, accessible, and consumer-friendly.
- Package code contains no product-specific behavior or duplicated design source.
- Relevant focused and broader validation passed, or the remaining validation
  boundary was reported.
- Breaking changes include versioning and migration treatment appropriate to the
  package's release status.
