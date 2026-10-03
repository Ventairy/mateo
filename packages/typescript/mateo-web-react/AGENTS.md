# Mateo Web React Package

This directory is the package root for `mateo-web-react`, the React implementation of
Mateo for websites and web apps, primarily for desktop with responsive mobile
support.

## Design ownership

Read the applicable [Mateo foundations](../../../design-system/foundation/)
before adding UI. Those artifacts own shared design decisions. Web component
contracts must be agreed before implementation; do not copy mobile interaction
rules or silently define web guidance in package code.

Use native React composition and web semantics. All components must support
keyboard and pointer input, accessible names and focus, localization, and reduced
motion.

## Test organization

- Colocate module and component tests with their source, using
  `<module>.test.ts` or `<component>.test.tsx`. For example, keep
  `src/palette/palette.test.ts` beside `src/palette/palette.ts` and
  `src/react.test.tsx` beside `src/react.tsx`.
- Keep each suite focused on the module it covers. Theme factory and CSS
  variable tests belong beside `src/theme.ts`, separate from palette tests.
- Reserve `test/` for package integration tests, shared setup and utilities,
  fixtures, and package-wide public type checks.
- Keep external consumer tests and their fixtures in `test/consumer/`. Test
  the packed, separately installed package through its public exports.
  Scripts may prepare and clean up that environment; assertions belong in tests.
- Exclude colocated tests from build output. Use the Node test environment for
  server-safe factories and the DOM environment for React behavior.

Run `pnpm run check` from this package for formatting, type checks, module tests,
build validation, and external consumer tests. Then run `pnpm run check` from
`packages/typescript/` for the workspace checks.
