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

## Pill geometry

A pill is a rounded rectangle whose effective corner radius is half its
shortest side:

```text
pill radius = min(width, height) / 2
```

The pill must remain fully rounded when its width, height, content, or text
scale changes. Prefer a platform's capsule or pill shape when one is available.
A very large numeric radius such as `999` or `9999` is also acceptable when the
rendering system automatically clamps it to half the shortest side. Those
numbers are implementation techniques, not additional Mateo radius values.

Examples:

| Size       | Effective pill radius |
| ---------- | --------------------- |
| `120 × 48` | `24`                  |
| `240 × 60` | `30`                  |
| `36 × 4`   | `2`                   |

## Circle geometry

A circle is the square form of `pill`. Give the element equal width and height,
then apply the pill shape:

```text
circle diameter = width = height
circle radius = diameter / 2
```

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
| Drag handles and skeleton text lines   | `pill`            |
| Icon-only and back buttons             | Circle            |
| Radial pulses                          | Circle by default |

Do not replace a component's pill with a smaller arbitrary radius to make it
feel more compact. Change its height, padding, or density instead; the fully
rounded silhouette remains part of the component.

## Rounded shapes inside other shapes

When one rounded shape sits inside another, their corners should follow the
same curve. Reduce the inner corner radius by the visible space between the two
shapes.

For example, if the outer radius is `24` and the space between the shapes is
`8`, use `16` for the inner radius.

This rule does not apply to pills. Each pill stays fully rounded based on its
own size.

## States and motion

- Keep a component's radius unchanged across resting, pressed, selected,
  loading, and disabled states.
- When a transition changes one component shape into another, interpolate the
  visible corners continuously. Do not let the surface become square midway.
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
