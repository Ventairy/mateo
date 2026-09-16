# Rounded-shape reference tools

The consumer specification is the
[rounded-shape foundation](../../design-system/foundation/rounded-shape.md).
These standard-library Python tools generate and verify its portable fixtures
and drawings. They do not run in a product.

From the repository root:

```sh
python3 tools/rounded_shape/reference.py
```

This generates `reference.json`, `reference.svg`, and `construction.svg`, then
runs verification. To check existing artifacts without rewriting them:

```sh
python3 tools/rounded_shape/verify.py
```

`reference.py` implements the documented axis fits, cubic shoulders, circular
arcs, reflections, and closed path. `artifacts.py` contains the representative
dimensions and usage-facing drawings. Inspect both SVGs after changes.

## Verification

`verify.py` checks the coefficients against the document, independent cubic
evaluation, circular arc radii, bounds, control ordering, zero/full rounding,
translation, invalid inputs, and artifact reproducibility. It also checks:

- Full-rounding squares contain four quarter-circle arcs with one center and
  no nonzero shoulders or straight segments.
- Cubic derivatives match the circle's tangent and curvature at each join;
  side joins have zero curvature. The near-collapse numerical tolerance
  accounts for subtraction of absolute coordinates whose normal separation
  decreases with the square of the shoulder angle.
- Increasing radius never moves the sampled directional supports outward
  across 45,600 configurations. Each support calculation uses the extrema of
  the cubic projection and the exact circular-arc extremum, rather than a
  sparse polyline.
- Radii approaching full rounding converge without a finite outline jump.

These checks are numerical evidence alongside the specification's analytic
join and circle construction. They are not a universal proof of every aspect
ratio, native rasterization, or platform performance.

The current fixtures use cubic and circular-arc commands. Do not compare
their topology or control points with the old exported paths. In an arc
command, `center`, `radius`, `startAngle`, and `endAngle` specify the circle
and its increasing-angle sweep; `points` contains its shared endpoint.
Top-right segment records include both endpoints. SVG output uses circular
arc commands, as defined by the
[SVG path specification](https://www.w3.org/TR/SVG/paths.html#PathDataEllipticalArcCommands).

Interpolation references retain their previous endpoints until that work is
revisited. This tool does not regenerate their artifacts or update platform
package implementations.
