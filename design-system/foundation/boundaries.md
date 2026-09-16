# Boundaries — Mateo Design System

A boundary is a place where content stops being visible because a viewport,
surface, mask, or changing shape contains it. Mateo never presents that
disappearance as a hard clip. Whenever content can pass into, move behind, or
be cut by a visible limit, a **boundary fade** must cover the geometric clip
and blend the content smoothly into the surface that owns the boundary.

This rule applies at physical display edges and everywhere else content is
contained: scrolling pages, nested panels, carousels, text editors, media,
maps, animated surfaces, and component-sized viewports. A hard clip may still
exist for layout, painting, hit testing, or performance, but it must not be the
visible result.

In this foundation, **boundary** means a content boundary. An outline,
separator, focus ring, selection edge, chart threshold, or geographic line can
remain crisp when it communicates structure or meaning; it does not cut
passing content and is not a boundary fade.

## The boundary rule

Every content boundary must follow all of these rules:

- Place a fade at every side where content can meet a clip.
- Keep the geometric clip behind the fade so no content escapes the owning
  shape and no hard cut remains visible.
- Fade inward from the exact clip line. Content is fully absent at that line
  and becomes fully visible at the inner end of the fade.
- Use the owning surface, not the passing content, to determine how the fade
  resolves visually.
- Leave a fully clear region where content can rest, be read, and be acted on.
- Draw exactly one fade when parent and child boundaries occupy the same
  visible line. The closest visible surface owns it.

If a fade would permanently obscure important content, change the layout so
the content can move into a clear region. Do not remove the fade and expose the
clip instead.

## Anatomy and ownership

A boundary has five parts:

1. **Owning surface:** the screen, panel, field, sheet, or other surface that
   defines the visible region.
2. **Passing content:** content that scrolls, translates, resizes, changes, or
   otherwise reaches beyond that region.
3. **Clip line:** the exact geometric limit beyond which the passing content
   must not paint.
4. **Fade band:** the region extending inward from the clip line over which
   the passing content disappears.
5. **Clear region:** the area beyond the fade band where content is fully
   visible.

The component that creates the clip owns the fade, its geometry, and its
state. A parent must not add another fade merely because a nested component is
near its edge. When a child boundary is visibly separate from its parent, each
surface owns its own fade and supplies its own local background.

## Fade construction

Measure progress through the fade along the inward normal: perpendicular to a
straight edge and directly away from the clip line.

- At the clip line, progress `x` is `0`.
- At the inner end of the fade, progress `x` is `1`.

First resolve the quintic smootherstep:

`q = 6x⁵ - 15x⁴ + 10x³`

Bias the passing content slightly toward the owning surface so it becomes
legible later, closer to the inner end of the fade:

`passing content = q × (0.12 + 0.88q) - 0.4q(1 - q)(q - 0.5)²`

An opaque surface-colored overlay uses the inverse opacity:

`overlay = 1 - q × (0.12 + 0.88q) + 0.4q(1 - q)(q - 0.5)²`

| Position through the fade | Passing content | Surface-colored overlay |
| ------------------------- | --------------- | ----------------------- |
| `0%` at the clip line     | `0%` visible    | `100%` opaque           |
| `0–100%`                  | Smooth curve    | Inverse smooth curve    |
| `100%` at the inner edge  | `100%` visible  | `0%` opaque             |

This curve begins and ends without a sudden change in slope. Its midpoint is
`72%` surface opacity rather than the symmetric curve's `50%`, keeping
passing content quieter until it is closer to the clear region. The final term
adds protection throughout both halves of the fade while resolving to zero at
the endpoints and midpoint. It keeps the geometric clip hidden at one end and
settles into full visibility without revealing where the fade ends at the
other.

Evaluate the curve continuously when the platform supports it. When an
implementation uses gradient stops, divide the fade into `32` equal segments,
producing `33` stops including both endpoints. Do not use fewer stops, add an
opaque plateau, or replace the curve with a short linear gradient. Those
shortcuts reveal a band or a second hard boundary inside the content.

### Opaque and transparent surfaces

When the owning surface has an opaque semantic background, draw the fade as a
foreground overlay using that exact background color. The opaque end must be
indistinguishable from the adjacent surface.

When the owning surface is transparent or composited over changing imagery,
apply the same curve as an alpha mask to the passing content. The mask reveals
the real layers behind the content instead of introducing a color that the
surface does not own.

Both techniques must produce the same observable result: the passing content
contributes nothing at the clip line and reaches full visibility only at the
inner edge. Do not blur the content, darken the boundary, add a divider, or
introduce a second color merely to hide the clip.

## Fade depth

Resolve depth from the local visible region owned by the boundary, not from an
unrelated ancestor or the full display. Use the region's height for top and
bottom boundaries and its width for left and right boundaries.

1. Start with one ninth of that local extent.
2. If the result is less than `64` density-independent units, use `64`.
3. If the result is greater than `96`, use `96`.
4. For a small region with one active boundary on an axis, do not let the fade
   exceed one half of the local extent.
5. For a region with opposing boundaries on the same axis, do not let either
   fade exceed one third of the local extent. This preserves at least one
   third of the region as a fully clear center.

Apply the small-region limit after the `64–96` range. For example:

| Local extent | Active boundaries | One ninth   | Resolved depth per boundary |
| ------------ | ----------------- | ----------- | --------------------------- |
| `120`        | top and bottom    | about `13`  | `40`                        |
| `400`        | top and bottom    | about `44`  | `64`                        |
| `700`        | top and bottom    | about `78`  | about `78`                  |
| `1,600`      | top and bottom    | about `178` | `96`                        |

A component may define a different exact depth when its content scale or
motion requires it. That value belongs in the component specification and
must still use the complete curve, hide the clip, and leave a fully clear
resting region. An explicit depth stretches or compresses the complete fade;
it must not preserve a fixed opaque subsection.

Resolve horizontal and vertical depths independently when a region has
boundaries on both axes. For a curved boundary, measure the resolved depth
along the inward normal so the fade follows the silhouette instead of forming
a rectangular band across it.

## Direction, shape, and corners

The opaque or fully masked end always touches the clip line. The transparent
or fully visible end always points into the clear region:

- top fades inward toward the bottom;
- bottom fades inward toward the top;
- left fades inward toward the right; and
- right fades inward toward the left.

Leading and trailing boundaries follow the resolved layout direction before
they become left or right. A boundary may be straight, rounded, curved, or
animated, but its fade and geometric clip must share the same silhouette at
every frame. Square gradient corners must never escape a rounded surface.

Where two boundary fades meet at a corner, combine their passing-content
visibility values by multiplication. If the horizontal curve resolves to
`0.5` and the vertical curve resolves to `0.5`, the content contributes `0.25`
at that point. For a surface-colored overlay, the equivalent combined opacity
is `0.75`. This produces one continuous corner treatment without a seam, hue
shift, or diagonal hard cut.

## Boundary state

The boundary belongs to the surface and stays fixed while content moves
beneath it. Its effective depth may reflect whether content actually extends
beyond that side:

- Let `D` be the resolved fade depth and let `d` be the hidden content distance
  beyond the boundary.
- If `D` is zero, the effective depth is zero and no division is needed.
- Divide `d` by `D` and constrain the result from `0` to `1`; call this progress
  `p`.
- Resolve effective depth as `D × (1 - (1 - p)⁸)`.
- When `d` is at least `D`, the effective depth is the complete resolved depth.
- When `d` is zero, the effective depth may be zero. The boundary still owns a
  fade; zero is its empty state, not permission to show a clip when content
  arrives.

For a scrollable region, use the hidden content distance before or after the
visible range for this state. A top fade can therefore grow as content moves
above the region, while a bottom fade can shrink as the end of the content
becomes fully visible. The eighth-power ease-out establishes about `90%` of the
protective depth within the first quarter of its scroll distance, before
passing content can compete with a fixed title or control.
If an implementation cannot measure overflow state, keep the complete fade
present rather than risk exposing a hard clip.

Do not pulse the fade or animate it independently as decoration. Changes exist
only to follow content overflow, boundary geometry, or the owning surface.

### Adaptive depth near resting content

Some scrollable regions need their first or last content to rest close to an
edge or rounded corner. A text editor, compact picker, or similarly bounded
surface would gain a large empty-looking area if its complete fade depth
remained present there. These boundaries must adapt their physical extent to
the scroll position. Changing only the fade's opacity is not sufficient.

Define a nonzero resting depth `R` that ends before the nearest protected part
of the resting content. The component specification must identify that
protected point and give `R` an exact value. The first line, item, caret,
control, or other informative content must remain completely beyond the inner
end of the resting fade.

Let `D` remain the complete resolved depth and let `d` be the hidden content
distance beyond the boundary:

1. Subtract `R` from `D` to find the expandable distance.
2. Divide `d` by the expandable distance and constrain the result from `0` to
   `1`; call this progress `p`.
3. Resolve effective depth as `R + (D - R) × p × (2 - p)`.
4. Stretch the complete canonical fade curve across that effective depth. Do not
   reveal the fade by cropping a fixed full-depth gradient.

The nonzero resting depth already protects close content, so this gentler
quadratic response preserves the surface's compact resting geometry. If `R`
equals `D`, the effective depth is always `D` and no division is needed. If the
component does not define a close-content resting state, use the general
eighth-power boundary-state formula instead.

For a leading boundary, `d` is the distance that content has moved beyond the
start of the scrollable range. The fade extends from `R` toward `D` as the
person scrolls away from the start. For a trailing boundary, `d` is the
remaining scrollable distance after the current position. The fade shrinks
from `D` toward `R` as the person approaches the end. Reverse scrolling and
right-to-left layouts must resolve leading and trailing before measuring `d`.

For example, consider a multiline writing surface with a complete depth of
`80`, a leading resting depth of `14`, and a trailing resting depth of `20`:

| State                         | `D`  | `R`  | `d`    | `p`    | Effective depth |
| ----------------------------- | ---- | ---- | ------ | ------ | --------------- |
| Leading content at rest       | `80` | `14` | `0`    | `0`    | `14`            |
| Leading content moved `16.5`  | `80` | `14` | `16.5` | `0.25` | `42.875`        |
| Leading content moved `66`    | `80` | `14` | `66`   | `1`    | `80`            |
| Trailing content at its end   | `80` | `20` | `0`    | `0`    | `20`            |

Recalculate adaptive depth whenever scrolling changes the position or
whenever content or viewport metrics change. This includes insertion,
deletion, text scaling, localization, resizing, keyboard changes, and
programmatic scroll correction. Update the fade in the same visual frame as
the new metrics so it does not lag, jump, or remain expanded after content
becomes shorter.

## Layering and interaction

Use this paint order:

1. the owning surface or the layers that should be revealed by a mask;
2. passing content, geometrically clipped to the owning shape;
3. boundary fades;
4. fixed app controls and scroll indicators that must remain fully visible;
   and
5. operating-system interface that paints above the app.

A boundary fade is visual only. It must not consume layout space, intercept
taps, drags, scrolling, pointer events, system gestures, or accessibility
exploration. It is not focusable and has no label, role, action, or
accessibility node of its own.

Although input passes through a fade, actionable or informative content must
not rest beneath it. Padding, scrolling limits, focus reveal, caret reveal, and
programmatic navigation must allow every item to reach the clear region before
it is read or used. Scroll indicators paint above the fade and remain fully
visible.

At physical mobile display edges, the app surface and passing content can
continue through safe areas while fixed controls remain inside their safe
content region. The [mobile system-controls guidance](../mobile/system-controls.md)
owns the platform-specific layering and symbol behavior.

## Transitions and reduced motion

When a transition changes the owning surface, clip shape, boundary position,
or fade depth, animate them as one continuous object:

- interpolate an overlay fade with the surface color;
- interpolate depth continuously instead of replacing one fade with another;
- grow an introduced fade from zero effective depth at its clip line;
- shrink a removed fade back to zero;
- keep the normalized opacity curve unchanged; and
- keep the fade clipped to the changing silhouette at every frame.

The fade must not flash, detach, expose a square corner, or reveal the hidden
geometric clip during a shared transition. Follow the
[animation foundation](animations.md) for continuity, interruption, and
reduced-motion behavior. With reduced motion, update the boundary without
spatial animation while preserving the correct final fade.

## What is and is not a content boundary

Boundary fades are required for:

- physical display edges where content passes beneath system or app controls;
- full-screen and nested scrolling regions;
- horizontal carousels, pickers, timelines, and continuously moving content;
- text, media, maps, canvases, and illustrations clipped by a component;
- rounded, irregular, resizing, or morphing surfaces that contain content;
- content disappearing behind a fixed header, footer, toolbar, or overlay; and
- any other place where visible pixels would otherwise end at a clip line.

The following are not content boundaries by themselves:

- the outline or shadow of a surface that contains no passing content;
- a divider or separator between adjacent regions;
- a focus, selection, validation, or drag-target indicator;
- a chart threshold, route, geographic border, or other meaningful line; and
- the natural end of content followed by empty layout space.

Do not describe an arbitrary crop as a meaningful edge merely to bypass the
fade. If content touches a geometric clip, the clip requires a boundary fade.

## Implementation contract

Every implementation that contains content must define:

- the owning surface and every side where passing content can meet a clip;
- whether each side uses a surface-colored overlay or an alpha mask;
- the semantic surface color or the layers revealed by the mask;
- the clip shape and the fade's matching silhouette;
- the resolved depth on each axis and any component-owned exception;
- how adjacent fades combine at corners;
- how overflow state changes each effective depth, including any protected
  resting point and exact resting depth;
- which fixed controls and indicators paint above the fades;
- how content reaches a fully visible, readable, and actionable position;
- how the boundary changes during surface and geometry transitions; and
- how the result behaves with layout direction, safe areas, text scaling,
  accessibility tools, and reduced motion.

## Validation

A Mateo boundary treatment is complete when:

- every side that content can cross has a boundary fade;
- no hard clip line appears along a straight edge, curve, rounded corner, or
  animated silhouette;
- passing content is absent at the clip line and fully visible at the inner
  edge;
- the full quintic-based curve has no opaque plateau, linear shortcut, band, or
  identifiable inner edge;
- sampled implementations use `32` equal segments and `33` stops;
- depth follows the local-extent rules or an exact component specification;
- opposing fades preserve a fully clear resting region;
- an overlay joins its semantic surface without a seam, and a mask reveals the
  correct layers without introducing a color;
- corner combinations follow the two-axis formula without a seam or hue shift;
- a zero-depth state occurs only where no passing content reaches that side;
- close-content scroll boundaries extend and shrink from current scroll and
  content metrics using the adaptive-depth formula;
- adaptive fades preserve their protected resting content, update without
  lag, and return to resting depth after content becomes shorter;
- every item can become fully visible, readable, and actionable;
- controls, scroll indicators, gestures, and pointer interaction work through
  or above the fades as intended;
- assistive technology ignores the decorative treatment; and
- transitions, reduced motion, text scaling, right-to-left layouts, safe-area
  changes, and the least capable supported device show no flash, seam, exposed
  clip, or unnecessary repainting.
