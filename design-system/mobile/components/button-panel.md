# Button Panel — Mateo Mobile

A Button Panel groups related actions inside one floating surface. The surface
separates the actions from the screen behind them and makes the buttons read as
one intentional set without turning them into a menu or modal choice.

Use a Button Panel when several actions belong to the same nearby context and
should remain visible together. Each button must perform its named action
directly when tapped. Do not use the panel for persistent or structural
navigation, filters, passive status, or controls that reveal another list of
actions. A button may open the destination or workflow named by its label when
activation goes there directly.

The component follows Mateo's
[border-radius](../../foundation/border-radius.md) and
[shadow](../../foundation/shadow.md) foundations. It uses the semantic roles
defined by the [mobile color scheme](../color-scheme.md). This document owns
the Button Panel's exact Android and iOS phone geometry and behavior. Tablets
and tablet-sized layouts are outside this specification.

All dimensions are mobile logical units.

## Anatomy

1. **Surface:** the deeply rounded background that visually contains the
   complete action group.
2. **Button stack:** one or more Mateo buttons arranged vertically in their
   visible and interaction order.
3. **Border:** a one-pixel boundary that keeps the surface edge clean against
   the surrounding screen.
4. **Shadow:** one centered, soft layer that makes the complete group read as
   floating above the background.

The panel has no title, handle, close button, scrim, selection state, or
independent touch target. If the actions need instructions or a heading to
make sense as a group, keep that content outside the panel or use a more
appropriate screen structure.

## Actions

Provide at least one Mateo button. Every button must belong to the same local
context, remain understandable on its own, and use a label that names the
result of tapping it.

Tapping a button immediately begins that button's action. The panel does not
open, close, expand, ask the person to choose again, or intercept activation.
Do not place an Action Bloom trigger, menu trigger, disclosure control, or a
button whose only result is another collection of actions inside the panel.
Opening the destination or workflow named by the button is a direct action;
revealing an intermediate action menu is not.

Use at most one primary button. When present, place it first. Order all
remaining actions from highest to lowest priority. Keep the complete set short
enough to remain visible and easy to scan. The panel does not wrap or scroll.
If the group cannot fit comfortably in the available safe content region, use
a dedicated screen or another component designed for overflow.

Each button retains its own variant, enabled, pressed, loading, and disabled
behavior. The panel does not recolor buttons or combine their accessibility
states.

## Layout and size

Arrange buttons from top to bottom. Center every button horizontally without
forcing equal widths.

| Measurement                  | Value |
| ---------------------------- | ----- |
| Space from panel edge        | `8`   |
| Gap between adjacent buttons | `8`   |
| Surface corner radius        | `36`  |
| Border width                 | `1`   |

The panel follows the resolved size of its buttons:

```text
panel width = widest resolved button width + 16

panel height = sum of resolved button heights
             + 16
             + 8 for every gap between adjacent buttons
```

A content-sized button keeps its natural width. A button configured to fill a
bounded width fills the available inner width, and the panel grows with it.
Other buttons remain centered and keep their own resolved widths. Do not
stretch every button merely because one action is wider.

Prefer placing the panel at the bottom of the screen, where its actions remain
easy to reach. The containing layout owns its exact position and must keep the
complete surface and shadow above the phone's bottom safe area. Leave clear
space between the panel and the screen edge so they read as separate shapes.

Do not attach the panel to the screen edge or reshape it to follow the phone's
border or corner radius. The panel keeps its own fixed silhouette because the
contained pill buttons use different geometry; making only the outer surface
follow the device would create a mismatched nested shape.

When the panel floats above scrolling content, keep it above that content
without adding a scrim or blocking the rest of the screen. The panel itself
adds no screen-edge inset or keyboard avoidance.

## Shape, color, and shadow

Use semantic colors from the [mobile color scheme](../color-scheme.md):

| Part    | Color role                |
| ------- | ------------------------- |
| Surface | `Button Panel.background` |
| Border  | `Button Panel.border`     |
| Shadow  | `Button Panel.shadow`     |

The surface uses a fixed `36` corner radius. Keep the background, border, and
shadow aligned to that same silhouette. The contained buttons retain their own
pill shapes.

Draw one shadow layer behind the complete panel:

| Horizontal offset | Vertical offset | Blur | Spread |
| ----------------- | --------------- | ---- | ------ |
| `0`               | `0`             | `41` | `0`    |

Keep the shadow unclipped and unchanged while any contained button is pressed,
disabled, or loading. The border and shadow communicate physical separation;
they do not indicate button state or action priority.

## States and motion

The Button Panel has one visual state. It adds no pressed, selected, disabled,
loading, entrance, exit, or rearrangement animation of its own.

Contained buttons provide their normal Mateo press feedback and own any
loading transition. If a button's resolved size changes, the panel follows the
new layout without adding another component-level motion. Reduced motion does
not change the panel because the panel itself does not animate.

## Accessibility

- Do not expose the surface as a button, modal, menu, or separate focus target.
- Expose every contained button independently with its complete accessible
  name, state, and action.
- Keep the accessibility order identical to the visible top-to-bottom button
  order.
- Do not merge the buttons into one action or require a screen reader to enter
  a separate group before reaching them.
- Ensure every button remains understandable without seeing the surface,
  border, shadow, color, or neighboring buttons.
- Preserve the buttons' normal touch targets and text scaling. Increase the
  panel's height as button content grows; do not reduce the `8` edge space or
  inter-button gap.

## Platform behavior

Use the same geometry, colors, shadow, direct-action behavior, and reading order
on Android and iOS phones. Interpret every measurement through the platform's
display density. Contained buttons retain their platform-native accessibility
and feedback behavior.

Portrait and landscape use the same panel rules. The containing layout decides
where the group fits within the current safe content region; the panel never
changes into a menu, sheet, or horizontal action bar because space is limited.

## Validation

A Button Panel is correct when:

- it contains at least one directly actionable Mateo button;
- all buttons belong to one local context and remain understandable alone;
- tapping any button begins its named action without revealing another action
  collection;
- buttons appear vertically in visible and accessibility order;
- every edge space and inter-button gap is exactly `8`;
- each button preserves its own resolved width and is centered in the panel;
- the surface has a `36` radius and one-pixel semantic border;
- the centered `41`-blur shadow remains soft, complete, and unclipped;
- button states do not change the panel's surface or shadow; and
- enlarged text and localization do not clip buttons or move the panel outside
  the available safe content region.

Validate the panel over plain and visually varied backgrounds, with one and
several buttons, mixed button widths and variants, loading and disabled
buttons, enlarged text, right-to-left content, portrait, and landscape.

## Good and bad use

| Good                                                         | Avoid                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------- |
| Two related actions that should remain visible above content | A button that opens an Action Bloom or another action menu    |
| One important floating action that needs surface separation  | Primary navigation, tabs, filters, or passive status          |
| Mixed-width buttons centered as one local action group       | Stretching every button only to make their widths identical   |
| Bottom placement kept clear of the phone's safe area         | Joining the panel to the edge or tracing the phone's corners  |
| A button that immediately opens its clearly named workflow   | A vague “More” button that reveals the real actions afterward |
