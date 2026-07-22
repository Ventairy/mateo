# Bottom sheet — Mateo Mobile

A Bottom Sheet presents compact information or a focused action above the
current screen while preserving the person's context. It is modal: the content
behind it is dimmed and unavailable until the sheet closes.

Use a Bottom Sheet when the task is short, related to the current screen, and
comfortable within a partial-height surface. Use a full-screen view for primary
navigation, long workflows, or large and unbounded collections. Do not open a
Bottom Sheet from another Bottom Sheet.

## Anatomy

1. **Scrim:** separates the sheet from the inactive screen and provides an
   outside dismissal area.
2. **Surface:** contains the sheet and follows the bottom display contour.
3. **Handle area:** keeps the drag affordance visible at the top of the sheet.
4. **Content area:** holds the information and actions supplied by the product.
5. **Scrolling region:** appears only in the scrollable variant and keeps the
   handle pinned while content moves.

The handle area is `32` high. Its centered handle is a `36 × 8` pill. Content
has `20` of minimum space on the left, right, and bottom, in addition to any
safe-area space it needs.

## Variants

### Content-sized

This is the default. The sheet follows the natural height of short content and
grows only as much as the content requires. Tall content stops at `85%` of the
keyboard-adjusted viewport.

Use this variant for compact details, choices, and actions that do not need
their own vertical scrolling behavior.

### Scrollable

The sheet starts at one third of the keyboard-adjusted viewport and can expand
to `85%`. An upward gesture expands the sheet first; after it reaches its
maximum height, the same gesture scrolls the content. The handle remains pinned.

## Placement and size

- Keep `12` between the sheet and the left, right, and physical bottom screen
  edges.
- Raise the sheet above the software keyboard instead of covering its content.
- Keep the sheet at or below `85%` of the available viewport height.
- On Android, place the outer bottom spacing above the system navigation safe
  area. On iOS, keep the surface near the physical bottom edge and protect its
  content with the internal safe area.

All dimensions are mobile logical units.

## Corner shape

The Bottom Sheet follows the shared [border-radius foundation](../../foundation/border-radius.md)
and [mobile display-boundary guidance](../border-radius.md). The values and
calculation below belong specifically to this component.

The surface uses a smooth, continuous corner curve. Its top corners use a base
radius of `36`. Its bottom corners begin at `36` and may become rounder so the
sheet follows the physical display corners.

When the system reports the display's bottom corner radii, resolve each side
separately:

```text
bottom-left radius  = max(36, display bottom-left radius - 12)
bottom-right radius = max(36, display bottom-right radius - 12)
```

The subtraction accounts for the `12` between the sheet and the display edge.
The `max` keeps the sheet at least as rounded as its base shape.

When exact display-corner information is unavailable:

- **Android mobile devices:** use `36` for every corner.
- **iOS mobile devices:** estimate the display radius from the largest top,
  left, or right safe-area value. Subtract the `12` outer spacing, then keep the
  result between `36` and `50`.

```text
estimated display radius = max(top, left, right safe area)
bottom radius = clamp(estimated display radius - 12, 36, 50)
```

Do not apply this shape to a full-screen view.

## Interaction and dismissal

The sheet can close through:

- a downward drag on the sheet;
- a downward drag on the scrim;
- a tap on the scrim;
- the platform back action; or
- the screen reader's dismiss action.

A drag begins only after at least `10` of clear downward movement, with more
vertical than horizontal travel. It closes the sheet when the downward velocity
reaches `100` logical units per second or the sheet has moved through at least
half its height. A clear upward release returns it to its resting position.

Content scrolling takes priority until the content reaches its top. A
scrollable sheet must also be back at its initial one-third height before a
downward sheet drag can dismiss it. This prevents reading gestures from closing
the surface unexpectedly.

## Drag resistance

The Bottom Sheet uses the shared [drag-resistance behavior](../drag-resistance.md)
when a drag moves toward a boundary with no active sheet action.

| Direction     | Maximum offset | Behavior                                                                                                      |
| ------------- | -------------- | ------------------------------------------------------------------------------------------------------------- |
| Left or right | `6`            | Resist in both variants because horizontal dragging has no sheet action.                                     |
| Up            | `6`            | Resist only in the content-sized variant. The scrollable variant uses upward movement to expand or scroll.   |
| Down          | `0`            | Do not resist because downward movement collapses or dismisses the sheet.                                    |

If a downward dismissal drag reverses, restore the sheet to its resting
position before upward resistance begins. Resistance must never be added on top
of the dismissal transform.

## Changing content

When an action replaces the Bottom Sheet's content, keep the existing sheet,
scrim, and handle. Animate the surface to the destination content's height
instead of closing it, opening another sheet, or changing its size abruptly.

For content that needs more space:

1. Measure the destination height within the sheet's `85%` limit.
2. Expand the surface to that height while the current content remains visible.
3. After the new space is available, transition to the destination content.

For example, a selection button may lead to a list of choices. Keep the current
Bottom Sheet open, expand it to fit the list, then replace the selection content
with the list. The person should experience one surface changing purpose, not a
second modal opening on top of the first.

When the destination is shorter, transition away from the current content
before contracting the surface so the outgoing content is not clipped. Keep the
bottom edge anchored and animate only the top edge to the new height. If the
destination exceeds the maximum height, expand to the limit and use the
scrollable behavior.

## States

| State            | Behavior                                                                                |
| ---------------- | --------------------------------------------------------------------------------------- |
| Resting          | The sheet is stable at its content-sized or initial scrollable height.                  |
| Expanding        | An upward gesture increases a scrollable sheet's height before moving its content.      |
| Scrolling        | At maximum height, vertical movement scrolls the content while the handle stays pinned. |
| Changing content | The same surface animates to its destination height and then presents new content.      |
| Dismissing       | The surface follows a valid downward drag and reveals more of the screen behind it.     |
| Returning        | A drag that does not commit animates back to the previous stable height.                |
| Closed           | The sheet and scrim are removed and the underlying screen becomes available again.      |

The Bottom Sheet has no selected or disabled variant. Loading and error states
belong to its content and must not change the sheet's geometry.

## Motion

- Enter over `400 ms` using an ease-out cubic curve. The surface rises from
  below the viewport while scaling from `96%` to full size, and the scrim fades
  in with the same easing.
- Exit or return from an incomplete dismissal over `270 ms` using an ease-out
  cubic curve.
- During a dismissal drag, connect the surface position and scale directly to
  the gesture.
- Coordinate content replacement with the size transition described in
  [Changing content](#changing-content). Do not replay the sheet's entrance
  animation.
- When reduced motion is enabled, remove the entrance, exit, and drag-follow
  animation. Apply content and size changes immediately while preserving every
  dismissal method and the final layout.

## Color

Use the [mobile color scheme](../color-scheme.md) rather than assigning palette
colors directly:

| Part    | Color role                |
| ------- | ------------------------- |
| Scrim   | `Overlay.scrim`           |
| Surface | `Bottom Sheet.background` |
| Handle  | `Bottom Sheet.handle`     |

The system navigation controls must remain legible against the scrim and sheet
while the modal surface is visible.

## Accessibility

- Give the scrim a localized dismissal label.
- Expose a screen-reader dismiss action on the surface. The visible handle is
  an affordance, not the only way to close the sheet.
- Keep content in a logical reading order and provide a clear title when the
  sheet needs one.
- After replacing content, announce the new context and move the screen-reader
  reading position to its title or first meaningful element. Do not announce a
  second Bottom Sheet, because the existing modal remains open.
- Allow text to scale without clipping. Switch to the scrollable variant or a
  full-screen view when enlarged content no longer fits comfortably.
- Do not rely on the drag gesture for an essential choice; provide explicit
  actions inside the content when a decision is required.

## Good and bad use

| Good                                                 | Avoid                                             |
| ---------------------------------------------------- | ------------------------------------------------- |
| A short set of filters related to the current screen | Primary app navigation                            |
| Compact details that can be dismissed without saving | A long, multi-step workflow                       |
| A bounded list of related choices                    | A feed or unbounded collection                    |
| Focused actions with clear labels                    | Nested vertical scrolling or another Bottom Sheet |

The content should remain understandable without instructions about how the
sheet itself works. If the task needs training text, multiple nested states, or
frequent navigation, give it a full-screen view.
