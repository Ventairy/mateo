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

Use the `mateo` or `Mateo` prefix only for Mateo-owned artifacts, including
private implementation helpers and test fixtures. Bundling a third-party asset
does not make it Mateo-owned: preserve its own name, such as `inter-variable.ttf`
for Inter fonts. Avoid repeating Mateo when an enclosing object or namespace
already provides that context.

- Use kebab-case filenames containing `mateo` for Mateo-owned files, such as
  `mateo-palette.ts`, `mateo-shape.ts`, and `use-mateo-surface-bounds.ts`. Colocated tests retain the
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
- Keep third-party API and asset names unchanged; Mateo-owned aliases follow
  this rule.
- Always prefix private functions and methods with `_`, such as
  `_getMateoShapeRadius` or `private _resolveBounds()`. This includes named
  functions and function-valued variables intended for use only within their
  file, even when they have no explicit `private` modifier. Keep the Mateo
  naming rules above after the underscore.

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

Type safety is mandatory for all TypeScript code: public APIs, components,
private helpers, scripts, tests, and fixtures. Every value and operation must be
type safe, and every contract must be explicit. Types must describe supported
behavior precisely and help consumers discover valid options through autocomplete.

- Make inputs, outputs, supported values, nullability, and optionality explicit
  in type contracts. Declare parameter and return types at API and module
  boundaries; use inference only where it preserves an equally precise contract.
- Treat untrusted or untyped data as `unknown` and narrow or validate it before
  use. Do not allow implicit or explicit `any` to carry unchecked data through
  implementation code, scripts, or test fixtures.
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

## Public API TSDoc

Add clear, consumer-facing TSDoc to everything consumers can access through the
public package API, including components, hooks, functions, classes, types,
constants, and their public members and props. Explain purpose, usage, defaults,
units, supported behavior, constraints, and meaningful edge cases as applicable,
so consumers understand the API from their editor. Use a brief summary and add
`@remarks`, `@example`, `@defaultValue`, `@param`, `@returns`, `@throws`, and
`{@link}` where they help; document intent and behavior rather than repeating
TypeScript types. Use the `tsdoc` skill when writing or reviewing these comments.
Private and internal implementation details do not require TSDoc. For generated
public APIs, maintain documentation in the owning source or generator rather
than hand-editing generated output.

Follow these consumer-facing documentation rules:

- Lead with the concrete outcome the API helps consumers achieve. Explain its
  purpose through familiar use cases before behavior details, configuration,
  or constraints; avoid abstract summaries when a direct description is clearer.
- Describe extensible containers, such as modules, namespaces, classes, and
  interfaces, by their stable domain or role. Do not define them by their first
  feature or enumerate their current operations, even as examples. Put
  feature-specific behavior on the member that provides it. Keep the summary
  concrete: do not merely restate the name or stored value with phrases such as
  "represents an X."
- Explain how to use the API, what it visibly or observably does, and constraints
  consumers must act on. Include technical details only when they change usage
  or an observable result, and describe their consumer-facing consequence.
  Keep internal coordination and optimization machinery out of public TSDoc,
  including frame scheduling, transform accumulators, caches, and batching.
- When an existing dedicated consumer guide provides useful detail, link to it
  from the owning declaration using its canonical GitHub URL so the link works
  in editors and generated API documentation. Keep detailed usage in that guide
  rather than duplicating it in every declaration.
- Describe an API's meaning rather than its current implementation. For semantic
  roles, explain the role itself; avoid baking in today's appearance, palette
  step, opacity, or rendering choice unless it is part of the public contract.
  A one-line summary is enough for a simple meaning; do not add remarks or
  caveats merely to make a comment longer.
- Update TSDoc when consumers need to discover a capability, change their usage,
  choose between meaningful options, or act on a non-obvious constraint. Do not
  mechanically expand comments for internal changes or fixes that restore
  behavior already implied by the public API.

For example, document a selection background as:

```ts
/** Background color for selected text. */
readonly selection: string;
```

Avoid describing that role as an "opaque pale accent background in the light
appearance"; those are current theme assignments, not the meaning of selection.

## Test Naming

Use `should <expected result> when <condition/action>` for TypeScript test
descriptions. For example:

```ts
it('should open the sheet when clicking the button', () => {
  // Arrange, act, and assert the observable behavior.
});
```
