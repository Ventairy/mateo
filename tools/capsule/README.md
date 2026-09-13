# Capsule reference tools

These tools retain the previous outline for the existing rounded convex
interpolation references. Current rounded geometry is defined by
[Rounded shape](../../design-system/foundation/rounded-shape.md) and its
[reference tools](../rounded_shape/README.md).

The previous specification is [the capsule reference](../../design-system/foundation/capsule.md).
These tools author and verify its portable reference artifacts. They are not
runtime dependencies or geometry lookup tables.

From the repository root, using Python 3 and its standard library:

```sh
python3 tools/capsule/reference.py
```

This generates the assets and immediately runs verification. A failed check
makes the command fail with a nonzero exit status.

To check existing assets without regenerating them:

```sh
python3 tools/capsule/verify.py
```

`reference.py` independently evaluates the specified geometry using de Casteljau
interpolation. `artifacts.py` writes the shared JSON fixtures, SVG silhouette
matrix, and curvature diagram.

`verify.py` is a regression check for the approved capsule geometry, not a
design-tuning tool. Keep it after the design is finalized to catch accidental
changes during maintenance. Run it after changing the equations, refactoring
the reference renderer, or regenerating geometry fixtures. It does not run in
applications, and ordinary component use or SVG color changes do not require it.

The check sweeps 1,818
proportions, densely covering the compact transition and checking extreme
ratios through 1,000,000:1. It checks finite bounds, monotonic quadrants, sampled
convexity, canonical tangent and curvature joins, closure, fixture consistency,
and the cubic conversion bound. Monotonic quarters and reflection exclude
self-intersections. Derivatives of vanishing segments cannot be resolved
reliably in binary64; the checks retain position validation and explicitly
exclude those segments from relative derivative comparisons.
