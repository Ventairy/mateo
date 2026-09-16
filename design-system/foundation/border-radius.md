# Border radius — Mateo Design System

Mateo uses deeply rounded shapes to make controls feel friendly, tactile, and
easy to recognize. Pill-shaped geometry is the default. It keeps attention on
the content at the center of a control and gives components a soft, lively
silhouette without adding decoration.

The shared foundation defines the pill shape rather than a scale of fixed
corner-radius numbers. Deep rounding also applies to surfaces that are not
pills or circles. Each component defines the fixed numeric radius that best
preserves this character at its size and on its platform.

## Deeply rounded geometry

Every Mateo element with rounded corners should look deliberately and
generously rounded. Avoid small radii that merely soften an otherwise square
shape. A non-pill surface keeps visible straight edges, but its corners should
still be a strong part of its silhouette.

For example, a `500 × 500` square may use a corner radius of `72`. It remains
clearly square while feeling unmistakably rounded.

This example communicates Mateo's visual character; it is not a ratio or a
reusable radius token. The component guidance owns the exact value and accounts
for the component's size, placement, content, nesting, and platform. Components
may use different fixed values, but they must preserve the same deeply rounded
quality.

## Rounded shape

Use the [Mateo rounded shape](rounded-shape.md) for rounded rectangles and
capsules. It gives them one shared construction, with soft shoulders that adapt
to the available width and height. A non-pill surface uses its
component-defined radius; a capsule uses full rounding.

The rounded-shape foundation defines the radius, axis fitting, coefficients,
and complete outline. Equal dimensions at full rounding give the circle
geometry below. The skeleton exception keeps its own geometry.

## Capsule

Use the [rounded-shape construction](rounded-shape.md#pills-and-circles) for
every pill- or capsule-shaped element, including controls, surfaces,
indicators, and decorative shapes. This rule applies regardless of the
element's size, orientation, or platform.

Request a radius of half the shorter dimension:

```text
pill radius = half the shorter dimension
```

The pill must remain fully rounded when its width, height, content, or text
scale changes. Re-evaluate the rounded shape from its current bounds.
Larger radius requests reach the same limit in this construction. A
conventional rounded rectangle with circular corners still produces a
different outline.

Examples:

| Size       | Effective pill radius |
| ---------- | --------------------- |
| `120 × 48` | `24`                  |
| `240 × 60` | `30`                  |
| `36 × 4`   | `2`                   |

## Circle geometry

A circle uses equal width and height and an exact circular outline:

```text
circle diameter = width = height
circle radius = diameter / 2
```

For center **(cˣ, cʸ)** and radius **r**, its boundary is
**(cˣ + r cos θ, cʸ + r sin θ)** for **0 ≤ θ ≤ 2π**.
Use the platform's circle primitive when available. It is the same geometry
as the rounded-shape construction with equal dimensions at full rounding.

Use a circle when the component contains one centered symbol or represents a
radial effect. Do not force text or changing-width content into a circle.

## Component shapes

Use the shape defined by the Mateo component whenever one exists.

| Component form                         | Shape             |
| -------------------------------------- | ----------------- |
| Text and icon buttons                  | `pill`            |
| Search controls                        | `pill`            |
| Floating button groups and action bars | `pill`            |
| Toasts and compact feedback surfaces   | `pill`            |
| Drag handles                           | `pill`            |
| Icon-only and back buttons             | Circle            |
| Radial pulses                          | Circle by default |
| Rectangular skeleton bones             | Material-style    |

Do not replace a component's pill with a smaller arbitrary radius to make it
feel more compact. Change its height, padding, or density instead; the fully
rounded silhouette remains part of the component. Skeleton bones are the
intentional exception because they represent content bounds rather than Mateo
controls.

## Rounded shapes inside other shapes

Choose the outer shape, inner shape, and spacing together. Components own the
dimensions, radius, and placement that make their nested shapes feel aligned.
Check the visible corner gap as well as the straight-edge padding.

Drawing a smaller rounded shape and subtracting the padding from its radius
does not generally produce a constant gap. Do not treat that shortcut as an
exact parallel outline. Borders, fills, and clipping should share the same
finished boundary.

## States and motion

- Keep a component's shape rule unchanged across resting, pressed, selected,
  loading, and disabled states. A capsule always derives its outline from its
  current bounds; a component with a fixed radius retains that radius.
- When a transition changes one component shape into another, interpolate the
  visible corners continuously. Use [rounded convex interpolation](rounded-convex-interpolation.md)
  for changes between convex outlines. Do not let the surface become square midway.
- End every shape transition on the exact destination shape defined by the
  component and its platform.
- Shape animation must preserve clipping for backgrounds, content, effects, and
  touch feedback so they remain inside the same moving boundary.

## Usage rules

- Use the component's existing radius before introducing a custom shape.
- Use `pill` for compact interactive elements even when their width is fluid.
- Use the intended platform's guidance for every fixed numeric radius. Do not
  infer a shared value from another platform.
- Use square corners intentionally. They should communicate full-bleed layout
  or attachment to another boundary, not an unfinished component.
- Keep borders, backgrounds, clipping, touch feedback, and shadows aligned to
  the same radius.
- Do not mix several nearby fixed radii to create visual hierarchy. Size,
  spacing, color, and elevation should carry that hierarchy instead.
