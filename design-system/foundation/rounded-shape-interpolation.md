# Rounded shape interpolation — Mateo Design System

Rounded shape interpolation changes a rounded shape's width, height, and
radius. A horizontal pill can become a vertical pill, a rounded rectangle can
grow or shrink, and a shape can gain or lose rounding. Every intermediate
outline follows Mateo's rounded-shape construction.

The [rounded-shape foundation](rounded-shape.md) owns the outline, radius
fitting, and corner coefficients. This document owns interpolation between
those shapes and their response beyond an endpoint. Width and height define
the shape's local bounds; the result is shape geometry. Placement, layout,
content, and component behavior belong to the caller. Follow
[animation](animations.md) for timing, gestures, velocity handoff, and reduced
motion.

## Endpoint values

Supply each endpoint's width **W**, height **H**, and requested radius **R**.
Dimensions must be positive and finite; the requested radius must be finite
and nonnegative. Empty bounds have no drawable outline and cannot be an
endpoint of this interpolation.

Before interpolating, resolve each endpoint's effective radius using the
rounded-shape foundation: **r** is the smallest of **R**, **W/2**, and **H/2**.
Keep only the three visible values **W, H, r**. Fit the radius at each endpoint
before blending; do not blend oversized requests and fit only afterward.

For example, a **96 × 96** rounded shape requesting radius **999** has effective
radius **48**. When its rounding changes to zero at the same size, its radius
at halfway is **24**. Blending the request of 999 would incorrectly leave it
fully rounded for most of that transition.

## Interpolation

Let **t** be finite progress supplied by a timing curve, spring, or gesture.
Zero selects source **A**; one selects destination **B**. For each of
**W, H, r**, use the same linear formula, including outside **0 ≤ t ≤ 1**:

**v(t) = (1 − t)vₐ + tvᵦ**.

This is equivalent to **vₐ + (vᵦ − vₐ)t**. Return the exact resolved endpoint
values at zero and one. Equal resolved endpoints remain stationary at every
progress value, including outside this interval.

At each frame, construct the ordinary rounded shape from the resulting
**W, H, r**, using the linked foundation's complete equations. Recalculate its
corner extents and shoulders from these values. Do not retain or interpolate
separate shoulder extents, angles, contour points, or curve controls.

For example, a **200 × 56** horizontal pill becoming a **56 × 200** vertical
pill, both with radius **28**, has these values:

| Progress | Width | Height | Radius |
| -------- | ----: | -----: | -----: |
| 0        |   200 |     56 |     28 |
| 0.25     |   164 |     92 |     28 |
| 0.5      |   128 |    128 |     28 |
| 0.75     |    92 |    164 |     28 |
| 1        |    56 |    200 |     28 |

The middle shape is the ordinary **128 × 128** rounded shape with radius
**28**. The sides and shoulders adapt to that frame's available space.
Radius zero produces the foundation's exact rectangle; equal dimensions at
full rounding produce its exact circle.

Within **0 ≤ t ≤ 1**, since **rₐ ≤ Wₐ/2** and **rᵦ ≤ Wᵦ/2**, their linear
blend also satisfies **r(t) ≤ W(t)/2**. The same holds for height. The effective radius therefore
fits throughout normal progress without an additional change of trajectory.

## Beyond an endpoint

Accept progress below zero and above one. Continue the same linear formula
for width, height, and effective radius. The supplied progress controls the
excursion directly, without size resistance, radius-progress softening, or
another easing curve. Timing belongs to the caller.

For example, width **100 → 200** becomes **210** at progress **1.1**, **250**
at **1.5**, and **300** at **2**. At progress **−0.1**, it becomes **90**.
There is no additional motion limit.

Keep only the constraints required to draw the rounded shape: after
interpolating the effective radius, raise a negative result to zero and
reduce a result exceeding **W/2** or **H/2** to the smaller of those limits.

For example, radius **20 → 0** stays at zero after progress one. Radius
**0 → 20** becomes **30** at progress **1.5** when the current dimensions
allow it. If the current shape is only **40** units wide, that radius fits
to **20** instead. Draw the ordinary rounded shape from the resulting three
values.

### Validity and continuity

Reject nonfinite progress and invalid endpoints. Reject a computed frame if
its dimensions cannot be represented as positive finite values, or its
interpolated radius is nonfinite before fitting. For example, width
**200 → 100** reaches zero at progress **2**, so that frame is invalid.
Do not substitute an unrelated shape for invalid input. Finite inputs alone
do not guarantee representable intermediate arithmetic at extreme scales.

The value of the outline stays continuous through both endpoints and through
radius-fitting limits. An active limit may change its derivative: zero
rounding cannot continue below zero, and a corner cannot grow beyond its
available bounds. The contract does not promise continuous velocity at every
geometric limit. The canonical rounded-shape construction owns its internal
curve joins; interpolation does not add another contour-smoothing pass.

## Reversal and interruption

Reversing the endpoint order and replacing **t** by **1 − t** retraces the
same valid frames, including their overshoot. Multiplying all endpoint
lengths by the same positive factor scales the movement by that factor, within
representable arithmetic.

When a transition is redirected, retain the visible **W, H, r** as its new
source. Retain the fitted visible radius, including any limit applied during
overshoot, rather than the original requested radius. Progress zero of the
new transition then reproduces the visible outline. No contour capture or
pair preparation is required.

This preserves geometric continuity. The caller owns velocity handoff and
timing under the animation foundation; restarting progress alone does not
preserve the previous velocity.

## Shape output across platforms

The equations are shared across platforms. A platform's number interpolation
helper may implement the linear step, but the resulting outline must still
follow Mateo's rounded-shape foundation and the overshoot response above.
Built-in rounded rectangles with a different corner construction do not define
this shape.

Keep full precision until drawing the outline. Reduced motion follows the
[animation foundation](animations.md#reduced-motion), with the same resolved
destination shape. Applying that shape immediately uses the same endpoint
values as reaching it through interpolation.
