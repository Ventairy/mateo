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
