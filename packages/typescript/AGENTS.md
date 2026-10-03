# Mateo TypeScript Implementations

This folder contains implementations of the Mateo Design System for frameworks
and platforms built on TypeScript. Its purpose is to turn Mateo's design
foundations into reusable packages that teams can use in their websites,
applications, and other TypeScript projects.

Each package owns the implementation for its framework and platform, including
its public APIs, components, and supporting code.

Packages share Mateo's design language while respecting the conventions and
capabilities of their target environment. Shared workspace tooling belongs at
this level; framework-specific behavior and instructions belong in the package
that owns them.

The authored design guidance remains in [`design-system/`](../../design-system/).
This folder implements that guidance. The repository and parent
[`packages/AGENTS.md`](../AGENTS.md) instructions also apply.

## Mateo naming

Keep Mateo context clear in package-owned names, including private
implementation helpers and test fixtures. Avoid repeating it when an enclosing
object or namespace already provides that context.

- Use kebab-case filenames containing `mateo`, such as `mateo-palette.ts`,
  `mateo-shape.ts`, and `use-mateo-surface-bounds.ts`. Colocated tests retain the
  same base name, such as `mateo-shape.test.ts`.
- Include `Mateo` in function, hook, class, interface, and type names, such as
  `getMateoShapeRadius`, `useMateoSurfaceBounds`, and `MateoShape`. Use `mateo`
  or `Mateo` in package-owned module constants and named helper callbacks too.
- Members of a Mateo-named object, class, or module namespace do not repeat
  `Mateo`: use `mateoPaletteValues.white`, not `mateoPaletteValues.mateoWhite`.
  Grouped value modules may export contextual member names such as `white` and
  `accent`; access them through a Mateo-named namespace. Standalone symbols
  still retain Mateo context.
- Apply the rule to source modules, scripts, integration tests, and fixtures.
  Ordinary parameters, local data variables, component props, and semantic
  object keys keep their descriptive names, such as `radius` and `accent`.
- Preserve names required by tooling, including `package.json`, `tsconfig.json`,
  `vite.config.ts`, `vitest.config.ts`, and `AGENTS.md`. Keep established package
  import paths stable when renaming source files.
- Keep third-party API names unchanged; Mateo-owned aliases follow this rule.

## Related values

- Group values that configure the same behavior in one small, Mateo-named
  readonly object. For example, keep press compression and release durations
  together in `mateoPressDurations`.
- Name members by their purpose and include units where needed, such as
  `compressionMs` and `releaseMs`, so different phases cannot be confused.
- Define each value once. Derive styling and runtime behavior from that same
  definition; do not repeat a duration in both a CSS utility and a timer.
- Keep the group beside the component or module that owns the behavior. Extract
  a shared module only when independent owners need the same configuration;
  do not combine unrelated settings into a global configuration object.

## Type safety

Use deep type safety for every component and supporting API in every TypeScript
package. Types must describe the supported contract precisely and help consumers
discover valid options through autocomplete.

- Preserve literal options and inference. Do not widen a closed set of values
  with `string`, `any`, or an unrestricted index signature that accepts typos or
  unsupported props.
- Model supported custom values with precise types, such as template literal
  types for CSS lengths, while preserving autocomplete for named options. For
  example, a size API should suggest `fit` and `fill` and reject `fil`.
- Encode required values, mutually exclusive options, and dependent props in
  the type contract. Keep nested configuration, callbacks, refs, and exported
  return values equally precise; use readonly types for immutable data.
- Prefer simple unions and native framework types where they express the
  contract. Introduce generics or advanced types only when they enforce a real
  constraint or preserve useful inference. Do not bypass safety with casts,
  non-null assertions, or `any`.
- Validate constraints that TypeScript cannot enforce at runtime, including
  values from JavaScript consumers. Do not claim that a template literal type
  validates the contents of a CSS expression.
- Cover meaningful accepted values and rejected usage with public type tests,
  following the parent testing guidance. Check built declarations through a
  separately installed consumer. Preserve useful inference and autocomplete by
  design; do not add language-service autocomplete tests by default.

## Test Naming

Use `should <expected result> when <condition/action>` for TypeScript test
descriptions. For example:

```ts
it('should open the sheet when clicking the button', () => {
  // Arrange, act, and assert the observable behavior.
});
```
