# Rounded-rectangle reference tools

These tools retain the previous outline for the existing rounded convex
interpolation references. Current rounded geometry is defined by
[Rounded shape](../../design-system/foundation/rounded-shape.md) and its
[reference tools](../rounded_shape/README.md).

The previous specification is [the rounded-rectangle reference](../../design-system/foundation/rounded-rectangle.md).
These tools generate and verify its portable references. They are not runtime
dependencies or geometry lookup tables.

From the repository root, using Python 3 and its standard library:

```sh
python3 tools/rounded_rectangle/reference.py
```

This generates the assets and immediately runs verification. A failed check
makes the command fail with a nonzero exit status.

To check existing assets without regenerating them:

```sh
python3 tools/rounded_rectangle/verify.py
```

`reference.py` evaluates the fixed degree-seven PH corner with de Casteljau
interpolation. Its positive-eigenvector construction preserves the approved
single flowing corner. `artifacts.py` generates JSON fixtures, the silhouette
matrix, and a curvature diagram. Insets use the exact rational PH normal
offset. Adaptive subdivision reserves half of the stated geometric error
budget for arithmetic and serialized coordinates; bounds whose binary64
spacing cannot resolve the budget are rejected.

`verify.py` independently converts the position polynomial to the power basis
and differentiates it. It checks 4,001 curve samples for tangent, curvature,
symmetry, monotonic turning, and the single central curvature peak. A 288-case
bounds and radius sweep covers dimensions from 0.000001 to 1000000000000,
aspect ratios through 1,000,000:1, both orientations, zero radius, and requests
immediately below, at, and above the fitting limit. Additional checks cover
closure, bounds, sampled convexity, translation, scaling, transposition,
normal-offset distance and curvature, invalid inputs, adaptive subdivision
bounds and independently evaluated points, and artifact reproducibility.
These are reference checks, not Flutter rendering or device validation.

Run the verifier after changing geometry or regenerating its artifacts.
Inspect both generated SVGs after changing their drawings. Numerical samples
are regression evidence; the polynomial and positive-weight convex-hull
construction supply the geometric definitions and approximation bound.
