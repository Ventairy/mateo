# Rounded-shape interpolation reference

The specification is the
[rounded-shape interpolation foundation](../../design-system/foundation/rounded-shape-interpolation.md).
These standard-library Python tools verify its equations. They do not run in
a product.

`reference.py` fits each endpoint radius, interpolates width, height, and
visible radius, and extrapolates linearly while retaining geometric validity constraints. A previous
`Frame` can be used as the source when redirecting a movement. `outline(frame)`
delegates to the canonical rounded-shape renderer.

From the repository root:

```sh
python3 tools/rounded_shape_interpolation/verify.py
```

The checks cover endpoint fitting, linear interpolation, zero rounding,
canonical shape output, linear extrapolation, radius fitting, extreme finite progress, invalid
inputs, reversal, scaling, stationary shapes, and geometric continuity when
retargeting.
