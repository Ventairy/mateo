# Mateo Design System Documentation

This file applies to everything under `design-system/`. The repository-level
`AGENTS.md` still applies, and a closer `AGENTS.md` may add platform-specific
instructions.

## Implementation-reproducible documentation

Every design-system document must be clear enough for a developer or coding
agent with zero prior Mateo context to produce a result consistent with the
real implementation.

- Document the observable contract, not only the idea behind it. Include the
  exact geometry, layout, visual treatment, states, interactions, motion,
  accessibility behavior, and platform differences needed to reproduce the
  result.
- Use measurable values for dimensions, limits, thresholds, durations, easing,
  offsets, opacity, and other visible behavior. Do not rely on adjectives such
  as "subtle", "smooth", or "rounded" without defining what they mean.
- Explain how values change over time or in response to input. When the exact
  relationship affects the result, provide the formula, interpolation, or
  ordered transition.
- Write math as explicit, human-readable steps. Do not use programming-language
  functions, pseudocode, or implementation expressions such as `clamp(...)`
  when plain language can state the same rule. Include concrete examples when
  minimums, maximums, ranges, or conditional calculations affect the result.
- Keep the guidance implementation-framework-agnostic unless a platform API is
  itself part of the design requirement. Different implementations may expose
  different configuration while producing the same Mateo result.
- Follow links to canonical parent documents for inherited rules and tokens;
  do not repeat them. The current document must define every decision owned by
  its scope and link directly to everything an implementer must also read.
- Compare documentation with the real implementation and its approved visual
  states before treating it as complete. Resolve or explicitly record any
  difference; do not let documentation and implementation silently describe
  different results.

Documentation is complete only when an independent developer or agent can use
it, together with its canonical linked documents, to reproduce the intended
look and behavior without inspecting the implementation source.
