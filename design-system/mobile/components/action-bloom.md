# Action Bloom — Mateo Mobile

Action Bloom transforms a Mateo Mobile button into a modal collection of
related actions. It preserves the source button's surface while expanding to
the nearest safe top or bottom edge of the phone. The person sees where the
choices came from, makes one choice, and returns to the same screen context.

Use the shared [Action Bloom foundation](../../foundation/action-bloom.md) to
decide whether the pattern fits. This document owns the Android and iOS phone
geometry, content, interaction, motion, and accessibility behavior. Tablets
and tablet-sized layouts are outside this specification.

The component also follows the shared
[animation](../../foundation/animations.md),
[border-radius](../../foundation/border-radius.md), and
[typography](../../foundation/typography.md) foundations, plus the
[mobile color scheme](../color-scheme.md).

All dimensions in this document are mobile density-independent units.

## Anatomy

1. **Source button:** a Mateo text button, icon button, or floating action
   button configured to open two or more related actions.
2. **Scrim:** the modal backdrop that separates the bloom from the underlying
   screen and provides a dismissal target.
3. **Bloom surface:** the source button's visible surface as it expands into
   the open panel.
4. **Action row:** one complete choice containing an icon, title, and optional
   description.
5. **Action icon:** the leading symbol that helps identify the choice.

The open panel has no title, handle, close button, border, or shadow. The
source label establishes the shared intent and each row names a complete
choice. If the collection needs another heading or instructions to make sense,
use a different component.

## Actions

Provide at least two actions. Prefer two to five. More actions are allowed only
while the set remains directly related and easy to compare; the panel scrolls
when the available safe height cannot contain them.

Each action requires:

- one icon;
- a one-line title; and
- an action to perform.

A description is optional and occupies no space when omitted. Use it to
distinguish similar consequences, not to restate the title. Preserve the
complete title and description for assistive technology even when visible text
truncates.

## Placement

The panel attaches to the safe top or safe bottom of the phone, whichever is
nearest to the source button's vertical center.

Resolve placement in this order:

1. The safe top coordinate begins after the top system area and any software
   keyboard occupying the top edge.
2. The safe bottom coordinate ends before any software keyboard occupying the
   bottom edge and before the bottom system area.
3. Measure from the source button's vertical center to each safe coordinate.
4. Attach to the top when the top distance is smaller.
5. Attach to the bottom when the bottom distance is smaller or the distances
   are equal.

The panel does not remain beside the source or choose the edge with the most
free space. It blooms toward the nearer safe edge so the source remains
spatially connected to the destination.

### Horizontal inset

Use `12` between the panel and each viewport side when the source leaves enough
horizontal room. If the viewport width minus the source width is less than
`24`, use half of that remaining width on each side. Never use a negative
inset.

The source may begin anywhere horizontally. Its exact bounds remain the
transition origin even though the open panel spans the resolved width.

### Safe height and overflow

The safe vertical span runs from the safe top coordinate to the safe bottom
coordinate. Limit the panel to `85%` of that span. Content that exceeds the
limit scrolls inside the panel; the panel does not grow beneath the keyboard or
system controls.

Keep at least `14` between the action collection and every panel edge. Increase
the horizontal content space only where needed to remain inside an asymmetric
left or right safe area. Calculate that safe space from the physical viewport
edge, accounting for the panel's existing horizontal inset so it is not added
twice.

At the attached vertical edge, the surface reaches the safe coordinate and its
content begins `14` inside it. The panel never extends into the top or bottom
unsafe region.

## Surface geometry

The open surface is a deeply rounded superellipse with a fixed `32` corner
radius. During opening, interpolate continuously from the source button's
resolved corners to that final shape. A pill or circle therefore remains
deeply rounded throughout the bloom instead of becoming rectangular midway.

Interpolate the surface from the source button's exact visible bounds to the
final panel bounds. Keep the complete action collection visually contained by
the changing boundary throughout the transition. The source position remains
the spatial anchor but is invisible, non-interactive, and absent from
accessibility until the panel has closed.

If the source has a border, draw it on the moving surface and fade its opacity
from full at closed to transparent at open. The final panel has no border.

## Action-row geometry

| Part                              | Value     |
| --------------------------------- | --------- |
| Horizontal row space              | `18`      |
| Vertical row space                | `14`      |
| Action icon surface               | `42 × 42` |
| Action icon                       | `24 × 24` |
| Gap from icon surface to text     | `12`      |
| Gap between action rows           | `6`       |
| Gap from title to description     | `2`       |
| Title line limit                  | `1`       |
| Description line limit            | `2`       |
| Overflow beyond either line limit | Ellipsis  |

Center the icon surface and text block vertically as one row. Keep the icon at
the leading edge and mirror the row in right-to-left languages. Do not shrink
the icon, gaps, or row space to fit longer text.

## Typography

Action text uses the shared Mateo typeface and letter spacing with these
component-owned values:

| Property    | Title   | Description |
| ----------- | ------- | ----------- |
| Font size   | `16`    | `14`        |
| Font weight | `600`   | `400`       |
| Line height | `1.25`  | `1.3`       |
| Alignment   | Leading | Leading     |

Allow the platform text scale to increase both styles. The panel may grow or
scroll within its `85%` height limit. Preserve complete localized strings for
assistive technology when the visible lines truncate.

## Color

Use semantic colors from the [mobile color scheme](../color-scheme.md):

| Part                        | Color source                                                                 |
| --------------------------- | ---------------------------------------------------------------------------- |
| Scrim                       | `Overlay.scrim`                                                              |
| Final bloom surface         | `Background.background`                                                      |
| Title                       | `Text.primary`                                                               |
| Description                 | `Text.secondary`                                                             |
| Default action icon surface | The source button's resting background                                       |
| Custom action icon surface  | The action's explicit semantic background                                    |
| Action icon                 | The source button's enabled foreground, unless the icon defines its own role |

During the first `30%` of opening progress, interpolate the bloom surface from
the source button's resting background to `Background.background`. Begin the
color change immediately, complete most of it early, and settle gently into the
final color. Hold that color for the remainder. Do not add a separate panel
color, border, or shadow.

An action with irreversible consequences still needs an explicit title and
icon. Color may reinforce that meaning but cannot carry it alone.

## Layering and interaction

Place the scrim above the current screen and the bloom surface above the
scrim. The open bloom blocks touch and accessibility interaction with the
underlying screen.

Actions do not respond to touch until the surface reaches its fully open state.
Once open:

- tapping an action gives it Mateo press feedback, starts closing, and performs
  that action once;
- tapping the scrim closes without performing an action;
- the Android or iOS system back action closes without leaving the current
  screen; and
- an attached keyboard's Escape key closes without leaving the current screen.

Action Bloom has no drag or swipe dismissal. Do not add a handle or borrow the
Bottom Sheet gesture.

When an action will navigate, replace the screen, or otherwise disrupt the
press feedback, wait for that feedback to finish before performing the
disruptive operation. Non-disruptive work may begin while the bloom closes.
Repeated activation during closing must not perform another action.

## Motion

### Opening

Open over `190 ms` with an ease-out cubic curve. Begin the expansion
immediately, cover most of the distance early, and settle gently into the final
panel without overshooting.

Across that progress:

- interpolate the surface bounds from the source button to the final panel;
- interpolate the source corners to the `32` panel radius;
- fade any source border to transparent;
- fade the scrim from transparent to `Overlay.scrim`; and
- move the action collection with the surface and keep it inside the changing
  boundary.

Keep the action collection fully transparent through the first `22%` of
opening progress. From `22%` to `100%`, fade it to full opacity, completing
most of the change early and settling gently. Do not stagger individual rows.

### Closing

Close over `180 ms` with an ease-in-out quadratic curve. Begin the return
immediately and settle gently as the surface reaches the exact source bounds.
Reverse the visible content, border, and scrim relationships with it. Keep the
source hidden until the bloom surface reaches its closed state, then remove
that surface and restore the source.

### Reduced motion

When reduced motion is active, present the fully open state immediately and
remove it immediately on dismissal. Preserve modal blocking, action feedback,
scrolling, focus, back behavior, and final geometry.

## Accessibility

- A text button uses its visible label as the source's accessible name.
- An icon or floating source requires a localized semantic label that describes
  the shared intent.
- Expose the closed source as a button that is currently collapsed and reveals
  additional choices.
- When open, remove the source and underlying screen from the active semantic
  order and expose the bloom as one modal context.
- Expose every action as an enabled button. Use its complete title as the
  accessible label and its complete description as the hint.
- Give the scrim the platform's localized modal-dismiss label and dismiss
  action.
- Move interaction focus into the modal context after opening. Restore the
  previously focused control after the bloom closes when that control still
  exists.
- Preserve the same reading order as the visible action order and mirror
  leading layout without reversing that logical order.

## Good and bad use

| Good                                                      | Avoid                                                    |
| --------------------------------------------------------- | -------------------------------------------------------- |
| “Proceed with payment” → Card, Pix, or bank transfer      | Opening a full payment form inside the bloom             |
| “Post” → Feed, Story, or community                        | Asking for caption, audience, schedule, and confirmation |
| “Create” → Note, folder, or reminder                      | One action or a long, mixed object menu                  |
| A floating object-action button with two to five commands | Primary navigation or a replacement for a Bottom Sheet   |
