# Dots loading indicator — Mateo Mobile

The Dots loading indicator is Mateo's compact indeterminate loading component.
Three solid circular dots rise and fall one after another in a continuous,
floating rhythm. The motion communicates that work continues without implying
a completion percentage.

Use it according to the [loading foundation](../../foundation/loading.md) when
an indeterminate indicator fits a compact mobile region or action. It does not
replace an animated skeleton, visual placeholder, or determinate progress
indicator when one of those communicates the wait more accurately. Its motion
also follows the [animation foundation](../../foundation/animations.md).

The component has no label, background, border, shadow, or interaction of its
own. The component that presents it owns its placement, accessible loading
description, and transition to the completed or failed state.

## Anatomy

The indicator contains exactly three identical dots in one horizontal row:

1. left dot;
2. center dot; and
3. right dot.

All three dots always use the same diameter and solid color. Only their
vertical position changes. Do not animate opacity, scale, color, rotation, or
horizontal position, and do not draw a visible baseline beneath them.

## Geometry

Let `r` be the radius of one dot in logical units.

```text
dot diameter = 2r
edge-to-edge gap = 1.35r
maximum jump height = 1.9r
indicator width = 3 × dot diameter + 2 × gap = 8.7r
indicator height = dot diameter + maximum jump height = 3.9r
```

For dot index `i`, where the left dot is `0`, the center dot is `1`, and the
right dot is `2`:

```text
center x(i) = r + i × (2r + 1.35r)
resting center y = 1.9r + r
```

The indicator includes no internal padding beyond this calculated footprint.
At rest, every dot touches the bottom of the footprint. At the top of a jump,
the dot touches the top. The complete animation therefore stays inside the
same bounds and never changes surrounding layout.

### Sizes

| Size    | Dot radius | Dot diameter | Gap    | Jump height | Complete footprint |
| ------- | ---------- | ------------ | ------ | ----------- | ------------------ |
| Default | `5`        | `10`         | `6.75` | `9.5`       | `43.5 × 19.5`      |
| Compact | `4`        | `8`          | `5.4`  | `7.6`       | `34.8 × 15.6`      |

Use the default size for standalone and region-level loading. Use the compact
size when another component, such as a button, needs the indicator to fit its
content area. If a component requires another dot radius, derive every other
measurement from `r`; never tune the gap or jump independently.

A radius of `0` produces an empty, zero-size indicator. Negative radii are
invalid.

## Color

When presented independently, all three dots use `primary-9` from the active
Mateo palette.

When embedded inside another component, use that component's active foreground
color so the indicator belongs to the surface it temporarily represents. For
example, a button uses its enabled foreground color while its action is
pending. Do not assume that `primary-9` is readable on every colored surface.

The dots are fully opaque. Do not add gradients or per-dot color changes.
Where the dots are the only visible loading cue, their color must have at least
`3:1` contrast against the immediate background.

## Motion

The complete loop lasts `1100 ms`. Drive it with a normalized linear progress
value `p` that increases from `0` to `1`, then repeats without delay.

Each dot uses the same lift curve with a phase offset. For dot index `i`:

```text
phase(i) = modulo(p - 0.18i + 0.06, 1)
lift(i) = 0.5 - 0.5 × cos(2π × phase(i))
center y(i) = 1.9r + r - 1.9r × lift(i)
```

`lift` is the proportion of the jump height travelled upward:

| Phase      | Lift   | Position         |
| ---------- | ------ | ---------------- |
| `0` or `1` | `0%`   | Resting baseline |
| `0.25`     | `50%`  | Halfway up       |
| `0.5`      | `100%` | Jump apex        |
| `0.75`     | `50%`  | Halfway down     |

The `0.18` phase separation equals `198 ms` of the full cycle between
corresponding points in adjacent dots. The `0.06` offset positions the sequence
across the loop boundary without changing its speed or spacing.

The left dot leads, followed by the center and then the right. As the right dot
finishes its movement, the left dot is already entering its next cycle. The
cosine relationship gives every dot zero vertical velocity at the baseline and
apex without holding at either point. The result should feel like three dots
floating in sequence, not balls striking a floor.

Do not apply another easing curve to the normalized loop progress. The cosine
lift already defines the acceleration and deceleration of each dot. Adding an
outer easing would create an uneven loop and a visible restart.

The sequence remains left-to-right in both left-to-right and right-to-left
interfaces. It expresses rhythm rather than reading order and does not mirror.

## States and lifecycle

| State                      | Observable behavior                                     |
| -------------------------- | ------------------------------------------------------- |
| Loading                    | The three dots repeat the defined motion continuously.  |
| Reduced motion             | All three dots remain visible on the resting baseline.  |
| Inactive or hidden         | The loop pauses without resetting its phase.            |
| Resumed                    | The loop continues from the phase at which it paused.   |
| Complete, empty, or failed | The owning component removes or replaces the indicator. |

The indicator has no entrance or exit animation of its own. Its parent owns
the state replacement and must follow the loading and animation foundations.
Stop animation work immediately when the indicator is removed. Pause it while
the software is inactive or the indicator cannot be seen.

The indicator emits no haptic feedback or sound.

## Reduced motion

When the phone requests reduced motion, stop the loop and place all three dots
on the resting baseline. Keep the same dot size, spacing, color, footprint, and
accessible loading state. Do not replace the component with one dot or hide it;
the static three-dot form, surrounding context, and accessibility state must
still communicate that the region is pending.

## Accessibility

- Expose the complete indicator as one indeterminate progress representation.
- Give the loading region or owning control an accessible name that identifies
  what is happening, such as “Saving” or “Loading more results.”
- Do not expose a percentage or progress value.
- Do not expose the individual dots as separate images or focus targets.
- Do not move screen-reader focus to the indicator.
- Keep the owning region marked busy until it becomes available, empty, or
  failed.
- Do not announce each jump or loop. Announce only meaningful loading-state
  changes according to the loading foundation.

The indicator is not interactive and has no touch target.

## Platform behavior

Use the same geometry, color behavior, and motion on iOS and Android phones.
Interpret every measurement as a logical unit through the platform's display
density, and expose the loading and busy states through its native
accessibility APIs. Do not substitute a platform spinner for this component.

Portrait and landscape use the same component. Its parent determines placement
and available space; the indicator itself never stretches to fill that space.

## Performance

Do not use one animated element per dot, blur, gradients, shadows, off-screen
buffers, or layout animation. Verify the indicator while the real pending work
is running on the least capable supported phone, not only in an idle preview.

## Validation

The Dots loading indicator is correct when:

- exactly three equal circles are visible;
- the default footprint is `43.5 × 19.5` logical units;
- the dots keep constant size, opacity, and color throughout the loop;
- the left, center, and right dots follow the same curve `198 ms` apart;
- each dot travels exactly `1.9` times its radius vertically;
- no dot paints outside the calculated footprint;
- the loop lasts `1100 ms` with no pause, hard landing, or visible seam;
- the static reduced-motion state shows all three dots on the baseline;
- pausing and resuming does not restart or jump the sequence;
- the indicator does not move surrounding content; and
- accessibility exposes one named, indeterminate loading state with no false
  percentage.

Review the animation at normal speed and in slow motion. Confirm the baseline,
apex, loop boundary, reduced-motion state, default and compact sizes, active
theme colors, and behavior while the software becomes inactive and active.

## Good and bad use

**Good**

- Center the default indicator in a compact region whose result is unknown.
- Use the compact indicator in a button while preserving the button's size and
  accessible action name.
- Place the default indicator after the last visible list item while more items
  load.

**Bad**

- Use it in place of a skeleton when the final page structure is known.
- Use it as a percentage indicator for measurable progress.
- Add more dots, vary their colors, or make them bounce with different curves.
- Overlay it on another loading primitive for the same region.
- Leave the loop running after loading completes or while it cannot be seen.
