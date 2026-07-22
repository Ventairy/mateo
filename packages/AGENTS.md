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

- Group implementations by ecosystem or framework, such as `flutter/`.
- Give each publishable library its own package directory, manifest, tests,
  documentation, changelog, license metadata, and validation commands.
- `flutter/mateo-mobile-flutter/` is the Flutter implementation of Mateo's
  mobile design system.
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

Every publishable package should explain:

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

- Follow the manifest, formatter, analyzer or linter, test runner, and build
  tools defined by the package being changed.
- Do not invent repository-wide package commands before the corresponding
  ecosystem configuration exists. Record exact commands in the nearest
  `AGENTS.md` when tooling is introduced.
- Test public API behavior, semantics, accessibility, state transitions,
  customization, and failure cases.
- Add visual or golden coverage where appearance is part of the contract, and
  update expected output only after confirming it matches the authored design.
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
