# Rounded convex interpolation reference tools

The consumer specification is the [rounded-convex-interpolation foundation](../../design-system/foundation/rounded-convex-interpolation.md).
These standard-library tools reproduce its equations, portable fixtures, and
SVG drawings.

Run from the repository root with Python 3.10 or later:

```sh
python3 tools/rounded_convex_interpolation/artifacts.py
```

This regenerates `reference.json` and four SVG drawings, then verifies their
geometry. Check existing artifacts without regenerating them with:

```sh
python3 tools/rounded_convex_interpolation/verify.py
```

The complete geometry sweep prepares hundreds of movement maps. The readable
Python reference favors direct equations over setup speed, so this is a long
check.

`reference.py` owns input validation, endpoint description and reconstruction,
dimensional continuation, and the paired evaluator. `geometry.py` owns physical
edge preparation, straight-feature selection, bounded physical outline progress,
and weighted closure. `motion.py` owns curve progress, convex disk opening,
weighted outline addition, and the monotone inverse movement map. Rounded pairs
prepare 257 samples in 64 support directions once, then evaluate their geometry
at the mapped parameter for each requested frame. Width and height use the
original progress. Pairs using physical edges skip map preparation.

`source-outlines.json` retains 16 finished cubic outlines and their dimensions.
They are interpolation examples; the capsule and rounded-rectangle foundations
remain authoritative for resting geometry. Illustrated pairs remain rounded
to rounded, while numeric checks also cover sharp convex inputs.

`reference.json` uses **Mateo rounded convex interpolation 6**. Endpoint records
contain the 512-interval description and 256-cubic independent fit. Frame
records contain clockwise polygon `points` in centered unit bounds. Multiply
x by `width` and y by `height` before adding screen position. Native paths need
not retain every reference vertex. The fixture covers 15 progress values for
each of eight pairs, including overshoot.

`reference.json` is the approved numerical baseline. Both the Python checks and
Flutter tests use it, together with `source-outlines.json`. The SVG drawings
show the same construction.

`verify.py` checks all 120 input pairs through 119 progress values, plus 4,608
aspect cases. It checks finite coordinates, closure, convex turns, winding,
bounds, positive dimensions, identity, reversal, endpoint independence, scaling,
invalid inputs, endpoint fit, scalar continuation, and reproducible JSON/SVG
artifacts. Polygon joins have no cubic C2 contract. Absolute pixel tolerances
do not imply exact scale invariance.

`verify.py` also compares rotating support evaluation with an independent full
vertex scan for the reference transitions.
Twelve rounded interruptions check exact captured endpoints and the following
curve fit. Three triangle transitions are checked at 500 intervals using 96 rotated support
directions, independently of the map's 256 intervals and 64 directions. In the
central 90% of the transition, interval movement must remain between 85% and 120%
of its mean. This measures normalized geometric movement, not frame rate or
identical velocity at every boundary point.

Dart tests separately check reference contours, native
float32 convexity and contour agreement, custom and canonical borders, retained
paths, repeated rounded interruptions, and movement rate. Run from
`packages/flutter/mateo-mobile`:

```sh
fvm flutter test test/foundation/mateo_rounded_convex_interpolation_test.dart test/foundation/mateo_rounded_convex_motion_test.dart test/widgets/mateo_rounded_convex_interpolation_golden_test.dart
```

Inspect all four generated SVGs and the CI goldens after changing their drawings.
Review motion at ordinary and slow speed, in reverse, and through overshoot.
Static images alone cannot establish coordinated motion. Keep resting-endpoint
agreement separate from intermediate-geometry agreement.

Create a transition when its endpoints change and reuse it throughout playback
so that movement-map preparation happens once for that pair.
