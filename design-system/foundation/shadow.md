# Shadow — Mateo Design System

Mateo uses shadow to show that a surface is floating above the interface. The
shadow is broad, soft, and low in contrast. It should make the separation feel
natural without drawing attention to itself.

Shadow is not decoration or a general hierarchy system. Use it for detached
surfaces such as floating actions and transient feedback. A surface does not
gain a shadow merely because it is important, interactive, or rounded.

## Visual character

A Mateo shadow should feel present before it looks visible. The person should
notice that the surface floats, not stop to notice the shadow that creates the
effect.

- **Subtle.** The surface remains the visual subject. If the shadow reads as a
  dark outline, a gray stain, or a separate shape, it is too strong.
- **Soft.** The shadow fades gradually into its surroundings. Avoid crisp edges
  and narrow dark rings around the surface.
- **Close.** The surface feels gently lifted from nearby content, not suspended
  far above the interface.
- **Shape-aware.** The shadow follows the exact outside edge of the surface,
  including its pill, circle, or deeply rounded corners. Use the shape from the
  [border-radius foundation](border-radius.md).
- **Stable.** The shadow and surface behave as one object. The effect does not
  pulse, glow, bloom, or lag behind the component.

## When a shadow belongs

Use a shadow when the complete component is visually detached from the layout
and occupies space above other content. Established examples include Toasts,
floating buttons, and floating search actions.

Overlap alone is not enough. Ordinary cards, sections, bars, fields, inline
buttons, and surfaces attached to a screen edge remain flat unless their
component specification defines them as floating.

Do not use shadow to:

- make a component look more important;
- replace spacing, grouping, borders, or background contrast;
- decorate every rounded surface;
- communicate pressed, selected, disabled, or error states; or
- create a reusable ladder of low, medium, and high elevation.

## Constructing a Mateo shadow

Begin with the least visible shadow that still separates the component from
the content beneath it. Give the shadow a wide, gradual fade and keep its
darkest area close to the surface. The result should remain quiet on plain
backgrounds without disappearing over visually varied content.

Prefer a neutral shadow color that belongs to the current appearance. Keep it
in the semantic color scheme rather than binding it directly to a palette
step. A shadow may use one layer or several layers when the component needs a
more natural transition between its near edge and its wider fade. Multiple
layers must merge into one continuous effect; no individual layer should be
recognizable.

Center the shadow when the component needs even separation in every direction.
Bias it slightly in the direction that best expresses the component's physical
placement when appropriate. Avoid long offsets that make the component look as
though it is hovering far from the interface.

Draw the shadow outside the component's silhouette and preserve enough paint
space for its complete fade. A clipped shadow creates a false hard edge. Keep
the background, border, clipping, touch feedback, and shadow aligned to the
same surface shape so the effect never reveals a square box behind a rounded
component.

## Component and platform ownership

This foundation intentionally defines no shared shadow values. Shadow rendering
varies by platform, and the right construction depends on the component's
shape, size, placement, movement, and the content it floats above.

Each platform component that uses shadow must define:

- whether the shadow is present and what makes the component floating;
- the number and rendering order of shadow layers;
- the semantic source color and opacity of every layer;
- the horizontal and vertical offset, blur, and spread of every layer;
- how much surrounding paint space is needed to prevent clipping;
- whether any interaction state changes the shadow;
- how the shadow behaves while the component enters, exits, or moves; and
- the backgrounds and visual states used to validate the result.

Those values belong to the component specification and its intended platform.
Do not copy values from another Mateo component or platform simply because its
shadow appears similar.

## States and motion

Keep the shadow unchanged across interaction states unless the component
specification defines a meaningful change in physical position. A color or
content state change does not imply a change in shadow.

When a floating surface enters, exits, or moves, transform the surface and its
shadow together. Do not animate blur, spread, or opacity as an independent
decorative effect. If reduced motion changes the component transition, the
shadow still remains attached to the surface throughout the resulting motion.

Shadow must never be the only indication of an action, state, boundary, or
reading order. The interface must remain understandable when the shadow is
difficult to perceive.

## Validation

A component's shadow fits Mateo when:

- the surface reads as floating before the shadow itself becomes noticeable;
- the shadow is soft enough that no dark ring or separate layer is visible;
- the surface feels close to the interface rather than dramatically elevated;
- the complete fade remains visible without a clipped edge;
- the shadow follows the component's exact silhouette;
- the component remains separated over both plain and visually varied content;
- interaction states do not change the shadow without a physical reason; and
- movement treats the surface and shadow as one object.
