# Drag resistance — Mateo Mobile

Drag resistance lets a component yield slightly when a person pulls it in a
direction where it cannot continue.

## Why it exists

Without this movement, the finger keeps travelling while the component remains
perfectly fixed. The boundary feels like an invisible wall. With resistance,
the component follows the finger by a small amount, then moves progressively
less as the pull continues. It feels as though a force is holding the component
in place instead of the interface simply ignoring the gesture.

The effect must remain subtle but noticeable. It gives a boundary physical
character without suggesting that the component can be freely moved,
reordered, or dismissed in that direction.

## When resistance applies

Use drag resistance when all of these are true:

- the component already responds to direct dragging;
- the person pulls toward a boundary the component cannot cross;
- leaving the component completely fixed would make the gesture feel
  disconnected; and
- a few units of movement will not obscure content or imply another action.

Do not use resistance as decoration or as a general response to every pointer
movement. If a drag is actively scrolling, expanding, collapsing, dismissing,
reordering, or navigating, that behavior owns the axis. Resistance begins only
at a boundary where the active behavior can no longer continue.

Never apply resistance on a scrolling axis while content can still scroll. Do
not combine action movement and resistance on the same axis at the same time.

## Movement model

Resistance is translation only. It does not resize, rotate, fade, or reflow the
component.

While the finger remains down, update the component continuously so it follows
the finger in the same direction. A drag to the right moves the component to
the right; a drag to the left moves it to the left. The same relationship
applies vertically. The component travels a much smaller distance than the
finger, but it must never lag behind in the opposite direction or wait until
release to respond.

For example, with a maximum horizontal offset of `6`, dragging the finger `48`
to the right places the component `2` to the right. Continuing to `96` moves the
component to `3`. Dragging left produces the same resisted movement toward the
left.

For each enabled axis:

```text
d = signed pointer distance from the drag origin
m = maximum component offset on that axis

resisted offset = sign(d) × m × (1 - 1 / (1 + abs(d) / 96))
```

The shared damping distance is `96` mobile logical units. Keep it consistent
across components; each component changes `m`, not the curve.

The movement begins with the first pointer movement and has no activation
threshold. It increases quickly enough to remain connected to the finger, then
slows continuously. The component approaches `m` but never reaches or crosses
it, even when the pointer travels much farther.

With an example offset of `6`, the curve resolves as follows:

| Pointer distance | Visible offset |
| ---------------- | -------------- |
| `24`             | `1.2`          |
| `48`             | `2`            |
| `96`             | `3`            |
| `192`            | `4`            |
| `384`            | `4.8`          |
| Continuing       | Approaches `6` |

Track distance from the original pointer-down position, not from the most
recent movement. When the pointer reverses, reduce the existing resistance
first. Movement in the opposite direction begins only after the pointer crosses
its original position.

## Choosing a maximum offset

Use `6` as the starting value for each enabled axis. This is the established
Mateo value and is suitable for both compact surfaces such as Toasts and large
surfaces such as Bottom Sheets because the damping curve keeps ordinary drags
small.

A component may choose a different maximum when its size or movement makes `6`
feel wrong:

- reduce toward `4` when `6` makes a compact or tightly spaced component look
  loose, draggable, or unstable;
- increase toward `8` only when `6` becomes imperceptible on a large component;
- choose horizontal and vertical values independently when the component's
  proportions or surrounding space differ; and
- use `0` to disable resistance on an axis.

Treat `4–8` as the normal Mateo range, not as a scale of reusable tokens. The
component guidance owns its exact maximum offsets and enabled directions.
Values outside this range require a clear interaction reason and visual review.
Do not increase the offset merely because the person can drag farther.

The right value should be visible when watching the component edge but easy to
miss when concentrating on the content. If the movement looks playful, bouncy,
or detachable, it is too strong. If the component still feels pinned to an
invisible wall, it is too weak.

## Direction ownership

Define resistance separately for up, right, down, and left. A component may
enable any combination.

- Enable a direction only when movement there has no active action.
- Disable a direction used for dismissal, scrolling, expansion, collapse,
  navigation, or reordering.
- When an action reaches its resting boundary and the pointer continues beyond
  it, finish restoring the action's movement before resistance takes over.
- Keep disabled directions exactly at rest; do not apply a smaller resistance
  value as a substitute.

Each component document must state the enabled directions and maximum offset
for each axis. It should explain which component behavior owns every disabled
direction.

## Release and interruption

When the pointer is released or cancelled, return the component from its
current resisted offset to rest over `180 ms` with an ease-out cubic curve.
Return without overshoot, bounce, or oscillation. The motion should feel like a
restraining force settling the component back into place, not a spring toy.

The resistance layer is visual feedback only. It must not consume the
component's tap, scroll, dismiss, or navigation action. Apply the translation
through a transform without relayout so surrounding content remains still and
the component's contents do not repaint solely because its position changes.

## Reduced motion

When the platform requests reduced motion or disabled animations, keep the
resisted offset at `0`. Preserve the underlying gesture and action without the
visual translation or return animation.

Resistance must not communicate information that is unavailable without
motion. It reinforces a boundary; it does not define the boundary by itself.

## Validation

A component using drag resistance is ready when:

- the component follows the finger continuously and in the same direction;
- a short pull creates a small but visible response;
- a long pull moves progressively less and never crosses the component's
  maximum offset;
- reversing the pointer removes the current offset before moving the other way;
- release and cancellation return cleanly to rest in `180 ms`;
- active scroll, dismiss, expand, collapse, reorder, and navigation gestures do
  not receive resistance on their movement axis;
- taps and other existing actions behave exactly as they do without resistance;
- surrounding layout remains fixed; and
- reduced-motion mode has no resisted translation.
