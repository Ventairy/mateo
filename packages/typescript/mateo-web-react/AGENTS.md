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

## Styling

Use Tailwind CSS through the package's Vite plugin for all component styling
and supported customization, including layout, spacing, colors, variants,
responsive behavior, and interaction states. Prefer Tailwind utilities over
handwritten CSS or inline style declarations whenever the styling can be
expressed statically.

Keep complete class names statically discoverable and prefixed with `mateo:`;
never construct utility names from runtime values. For dynamic dimensions,
palette colors, or padding, prefer CSS custom properties consumed by static
Tailwind utilities. Limit inline styles to supplying runtime values that cannot
be generated ahead of time.

Customization remains available only through each component's supported Mateo
props. Using Tailwind internally does not introduce consumer `className`,
`style`, or arbitrary utility escape hatches. Do not introduce Tailwind's default
design tokens as Mateo foundation values.

Compile package-owned utilities into `dist/styles.css`, exported as
`mateo-web-react/styles.css`. Consumers import that stylesheet once; they do not
need Tailwind installed or configured. Keep CSS marked as a package side effect.
Omit Preflight and global resets, and scan only the component source directory.
Verify the compiled stylesheet through the external consumer tests and browser
layout checks when component styling changes.

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
