# Mateo Web React Package

This directory is the package root for `@mateo/web-react`, the React implementation of
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

## Component props

Keep each component's props focused on its purpose and concrete supported use
cases. Every prop must have a clear reason to belong to that component; do not
add props simply because HTML or React makes them available, or inherit broad
DOM prop bags for convenience.

Prefer a small, semantic API and native composition. Use inherited context for
settings such as language and text direction when it serves the component's
contract. Preserve the props needed for accessibility and supported interaction
without adding unrelated customization options.

## Source organization

- `src/components/` contains product-facing components and their colocated tests.
- `src/bases/` contains shared internal implementation components. Use the
  `BaseMateo` prefix and a matching kebab-case folder and filename, such as
  `src/bases/base-mateo-surface/base-mateo-surface.tsx`. Keep bases out of public
  package exports.
- `src/foundation/` contains non-component foundations and supporting utilities,
  including shape contracts, geometry, and bounds measurement.
- `src/theme/` contains theme data, React theme integration, palettes, and their
  supporting color utilities.
- Keep tests beside the implementation they cover. Package entry modules and
  the stylesheet remain at the source root.

Keep rendering, layout, lifecycle, and private React context with the component
or base that owns the behavior. Extract a base when multiple components need the
same implementation; keep their public contracts and defaults with each
component. Do not move component-specific code into foundation merely because
it could be reused later.

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
`@mateo/web-react/styles.css`. Consumers import that stylesheet once; they do not
need Tailwind installed or configured. Keep CSS marked as a package side effect.
Omit Preflight and global resets, and scan only the component and base source
directories.
Verify the compiled stylesheet through browser layout checks when component
styling changes.

## Test organization

- Colocate module and component tests with their source, using
  `<module>.test.ts` or `<component>.test.tsx`. For example, keep
  `src/theme/mateo-palette/mateo-palette.test.ts` beside `src/theme/mateo-palette/mateo-palette.ts` and
  `src/mateo-react.test.tsx` beside `src/mateo-react.tsx`.
- Keep each suite focused on the module it covers. Theme factory and CSS
  variable tests belong beside `src/theme/mateo-theme.ts`, separate from palette tests.
- Reserve `test/` for package integration tests, shared setup and utilities,
  fixtures, and package-wide public type checks.
- Exclude colocated tests from build output. Use the Node test environment for
  server-safe factories and the DOM environment for React behavior.

Run `pnpm run check` from this package for formatting, type checks, module tests,
and build validation. Then run `pnpm run check` from
`packages/typescript/` for the workspace checks.

## Golden Tests

- Colocate `mateo-*.golden.test.tsx` suites with their components. Use the shared
  helpers in `test/golden/`, public package exports, and built package CSS. Keep
  scenario names stable and group related cases into labeled reference images.
  Capture settled interaction states before releasing input, then compare their
  combined image. Test canvas styling must not override component CSS.
- References live in colocated `__screenshots__/` directories and belong in Git.
  Actual/diff/failure images live under ignored `.vitest/`; CI uploads them on
  failure. Delete stale reference PNGs when removing or renaming a scenario.

## Browser Behavior Tests

Colocate `mateo-*.browser.test.tsx` tests for native event ordering and geometry
that jsdom cannot reproduce. These reuse the browser helpers and built package
CSS without adding appearance references. Run `pnpm run build` followed by
`pnpm run test:browser:run`; package and workspace `check` include this suite.
Use `MATEO_BEHAVIOR_BROWSER=firefox pnpm run test:browser:run` or
`MATEO_BEHAVIOR_BROWSER=webkit pnpm run test:browser:run` for other installed
Playwright engines. Chromium remains the default and the sole golden engine.
