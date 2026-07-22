# Viewport edges — Mateo Design System

Mateo softens the top and bottom of a viewport so content does not appear to
end at a hard horizontal cut. A gradient blends the active surface into the
content, letting items enter and leave the visible area gradually. The screen
feels open and continuous instead of framed by two rigid boundaries.

This treatment is called an **edge fade**. It is part of the viewport, not the
content being shown, and remains fixed while content moves beneath it.

## Edge-fade construction

Place one fade across the full width of the top edge and another across the
full width of the bottom edge. Each fade is a foreground overlay above the
scrolling content.

The gradient uses the semantic background color of the surface that owns the
viewport. It follows three stops measured from the outside edge toward the
center of the viewport:

| Position through the fade | Color                                     |
| ------------------------- | ----------------------------------------- |
| `0%`                      | Background color at `100%` opacity        |
| `30%`                     | Background color at `100%` opacity        |
| `100%`                    | The same background color at `0%` opacity |

Interpolate color and opacity continuously between the stops. The first 30%
creates a calm area at the physical edge; the remaining 70% makes content
appear or disappear gradually. Do not replace this with a short two-stop fade:
it exposes content too close to the edge and makes the boundary visible again.

The direction mirrors by edge:

- The top fade is opaque at the top and transparent toward the center.
- The bottom fade is opaque at the bottom and transparent toward the center.

The default fade depth is one seventh of the viewport height. Measure it in the
platform's density-independent layout units, then apply these boundaries:

- If one seventh is less than `72`, use `72`.
- If one seventh is greater than `120`, use `120`.
- Otherwise, use the result of dividing the viewport height by seven.

For example:

| Viewport height | One seventh | Fade depth |
| --------------- | ----------- | ---------- |
| `400`           | about `57`  | `72`       |
| `700`           | `100`       | `100`      |
| `1,600`         | about `229` | `120`      |

Both edges use the same resolved depth. A component may define a different
depth only when its viewport is substantially smaller than a full screen or
its visual surface requires a different transition; that exception belongs in
the component or platform specification.

## Surface continuity

The opaque end of the fade must be indistinguishable from the surrounding
surface. Resolve its color from the active semantic background rather than a
fixed palette value. If a viewport sits inside a differently colored surface,
use that local surface color for both fades.

Keep the overlay and its surface in the same clipped boundary. A rounded or
changing viewport clips the fade to the exact same shape so square gradient
corners never escape its silhouette.

Do not blur the content, add a divider, darken the edge, or introduce a second
color into the gradient. The disappearance of content creates the depth; the
edge itself should not become a visible object.

## Layering and interaction

Use this paint order:

1. viewport background;
2. content that can move beneath the edges;
3. top and bottom edge fades; and
4. controls or system interface that must remain fully visible above the fade.

An edge fade is visual only. It must not intercept taps, drags, scrolling,
pointer events, or accessibility exploration. It does not become a focusable
element and has no accessible label of its own.

Although input passes through the overlay, do not leave an actionable control
at rest beneath its opaque area. Layout and scroll boundaries must allow
important content to reach a fully visible position before it is used. Content
may pass through the fade while entering or leaving the viewport.

Keep scroll indicators and app-owned navigation bars or toolbars visually above
or outside the fade according to their component specifications. System
controls also paint above the fade, but a platform may extend the fade beneath
their transparent region to the physical device edge. The platform document
owns that layout; see [mobile system controls](../mobile/system-controls.md).
The fade must never cover a scroll indicator or system control.

## When to use an edge fade

Use top and bottom edge fades when content moves through the viewport and a
plain crop would create a visible horizontal boundary. This includes scrolling
pages, feeds, lists, and continuously changing content surfaces.

Do not add an edge fade when:

- the content is intentionally full-bleed to the physical edge, such as an
  immersive image, camera preview, or map;
- a component has a meaningful visible boundary that people need to perceive;
- content ends inside the layout rather than passing through the viewport;
- a fixed surface already covers and resolves the edge; or
- the fade would hide information that cannot move into a fully visible area.

An edge fade makes a viewport feel continuous, but it is not the only signal
that content can scroll. Layout, partial content, platform behavior, and scroll
feedback must still make movement understandable.

## State and motion

The fade stays fixed while content scrolls. Do not pulse it, move it with the
content, or change its opacity in response to normal scroll position. The
content crossing the stationary gradient produces the effect.

When a transition changes the viewport background, shape, or fade depth,
animate the fade as part of the same surface:

- interpolate the fade color with the surface color;
- interpolate its depth continuously rather than replacing it;
- grow a newly introduced fade from zero depth at its edge;
- shrink a removed fade back to zero depth; and
- keep the gradient stops at `0%`, `30%`, and `100%` throughout.

The fade must not flash, detach, or reveal a hard edge during a shared element
transition. Follow the [animation foundation](animations.md) for continuity,
interruption, and reduced-motion behavior. With reduced motion, update the fade
without spatial animation while preserving the correct final gradient.

## Implementation contract

An implementation of viewport edge fades must define:

- which surface owns the viewport and supplies its semantic background color;
- whether both vertical edges are present;
- the resolved fade depth and any component-specific exception;
- the overlay and clipping boundaries;
- which fixed controls paint above the fades;
- how content receives enough space to become fully visible and actionable;
- how the fades change with surface transitions; and
- how the result behaves with safe areas, text scaling, accessibility tools,
  and reduced motion.

## Validation

A Mateo viewport edge treatment is complete when:

- content enters and leaves through a gradual fade rather than a hard line;
- both fades span the viewport and mirror each other vertically;
- the outer 30% is visually identical to the owning surface;
- the transition reaches complete transparency at the inner edge;
- the default depth follows the viewport formula and its limits;
- no seam appears between the fade and its surface;
- gradients remain clipped to rounded and animated viewport shapes;
- every item can reach a fully visible, readable, and actionable position;
- scrolling and all pointer interactions work through the overlays;
- assistive technology ignores the decorative gradients; and
- transitions, reduced motion, and the least capable supported device show no
  flashing, clipped gradients, or unnecessary content repainting.
