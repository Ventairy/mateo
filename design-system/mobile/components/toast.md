# Toast — Mateo Mobile

A Toast presents a short, transient message above the current screen without
interrupting the person's task. It is a compact floating pill that appears near
the top of the phone, announces its message, remains visible long enough to
read, and then dismisses itself.

Use a Toast for immediate feedback that does not require a decision. Use a
persistent inline message or dedicated error state when the information must
remain available, contains an action, or prevents the person from continuing.
A Toast is not a dialog, notification inbox, banner, or replacement for field
validation.

The component follows Mateo's [animation](../../foundation/animations.md),
[border-radius](../../foundation/border-radius.md),
[shadow](../../foundation/shadow.md), and
[typography](../../foundation/typography.md) foundations. This document owns
the exact mobile values and behavior of the Toast.

## Anatomy

1. **Surface:** a floating pill that contains and clips the complete Toast.
2. **Status icon:** identifies the message category without relying on color alone.
3. **Message:** a concise description of what happened.
4. **Shadow:** separates the Toast from plain and visually varied content.

The Toast has no title, close icon, progress bar, or action button. The complete
surface is the dismissal target.

## Status

Choose the status from the meaning of the message, not from the color a product
prefers.

| Status  | Use for                                                                             | Default icon           |
| ------- | ----------------------------------------------------------------------------------- | ---------------------- |
| Error   | A failed action, unavailable result, or invalid state                               | `exclamation-circle`   |
| Warning | A non-blocking risk, degraded condition, or unexpected outcome that deserves notice | `exclamation-triangle` |
| Info    | Timely contextual information that helps the person understand the current task     | `circle-info`          |
| Success | A meaningful action or awaited process that completed as expected                   | `circle-check`         |
| Neutral | Object or system status that carries no success, warning, or error meaning          | Custom icon required   |

Error, Warning, Info, and Success provide a default icon. Replace one only when
a more specific Mateo icon explains the message more clearly. Neutral has no
default and must receive a relevant custom icon; it never appears without an
icon. Every custom icon follows Mateo's icon guidance, keeps the `30 × 30` slot,
and uses the active status icon color.

The message must communicate the complete meaning without the icon or color.
The icon reinforces the status visually; it does not replace clear words.

### Choosing a status

- Use Error after something has failed. Do not use Warning to soften a failure.
- Use Warning for a condition the person should notice but can safely leave
  without responding. Use a persistent or interruptive component when a risk
  requires a decision or could cause irreversible harm.
- Use Info for a timely fact or tip that is relevant to what is happening now.
  Do not interrupt the person with unsolicited onboarding advice or unrelated
  education.
- Use Success when confirmation is valuable, especially after an action or
  process whose completion the person was waiting for. Do not announce every
  routine tap or expected state change.
- Use Neutral for domain-specific status that has no severity, such as
  “Headphones at 80%.” Do not use it as a fallback when the correct status is
  unknown.

| Good use                            | Why it fits                                                  |
| ----------------------------------- | ------------------------------------------------------------ |
| Error: “Message couldn't be sent.”  | A requested action failed.                                   |
| Warning: “Working from saved data.” | The task can continue under a degraded condition.            |
| Info: “A copy was saved offline.”   | A timely fact explains the current state.                    |
| Success: “Download complete.”       | An awaited process finished successfully.                    |
| Neutral: “Headphones at 80%.”       | The message reports object status without implying severity. |

| Bad use                             | Why it does not fit                                          |
| ----------------------------------- | ------------------------------------------------------------ |
| Success: “Item selected.”           | The routine state change is already visible.                 |
| Warning: “Delete all files?”        | Irreversible risk requires a decision before the action.     |
| Info: “Did you know you can swipe?” | Unsolicited instruction is not timely status feedback.       |
| Neutral: “Something happened.”      | Neutral is not a fallback for an unknown or unclear outcome. |

Do not use a Toast when the message is persistent, actionable, blocking,
critical, or likely to be revisited. Keep that information in context with an
inline message or banner, or use a dialog when an immediate decision is
required.

## Placement and layering

Place the Toast in a dedicated feedback layer above the current screen,
navigation transitions, shared-element transitions, and route-owned overlays.
It must remain visible and interactive while content underneath transitions.

- Align the Toast to the horizontal center of the phone.
- Place it after the top safe area with `16` of top space.
- Keep at least `20` between the Toast and each horizontal safe-area edge.
- Let short Toasts use their natural width. Do not stretch them to fill the
  available width.
- Limit long Toasts to the width remaining after the horizontal spaces.
- Keep the Toast near the top in portrait and landscape. Do not move it to the
  bottom when the software keyboard appears.

All dimensions in this document are mobile logical units.

Only one Toast is visible at a time. When a new Toast is presented, remove the
current Toast immediately and present the new message in the same feedback
layer. Do not stack, queue, or overlap Toasts.

## Geometry

The surface uses the `pill` shape from the
[border-radius foundation](../../foundation/border-radius.md). Its radius must
remain half its rendered height as text size or line count changes.

| Part                                    | Value     |
| --------------------------------------- | --------- |
| Icon slot                               | `30 × 30` |
| Gap between icon and message            | `12`      |
| Top and bottom content space            | `14`      |
| Leading content space, one-line message | `14`      |
| Leading content space, two-line message | `18`      |
| Trailing content space                  | `26`      |
| Message line limit                      | `2`       |

The icon and message are vertically centered as one row. The status icon fills
the `30 × 30` slot. Keep the icon at the leading edge and mirror the row for a
right-to-left language.

The Toast's natural size is:

```text
content height = max(30, message block height)
toast height = content height + 28

toast width = leading space + 30 + 12 + message width + 26
```

Constrain the message before calculating the final width. When it needs a
second line, use the two-line leading space. Truncate content beyond the second
line with an ellipsis. Do not reduce the icon, gap, or content spaces to fit a
long message.

## Typography

Use the shared Mateo typeface and letter spacing with these component values:

| Property      | Value                                    |
| ------------- | ---------------------------------------- |
| Font size     | `14.5`                                   |
| Font weight   | `600`                                    |
| Line height   | Inter's natural line height at this size |
| Alignment     | Leading                                  |
| Maximum lines | `2`                                      |
| Overflow      | Ellipsis                                 |

Do not underline or decorate the message. Preserve the complete localized text
for accessibility even when the visible message is truncated.

## Color

Use the [mobile color scheme](../color-scheme.md). Do not assign palette colors
directly.

The active status selects the matching `Toast — Success`, `Toast — Error`,
`Toast — Warning`, `Toast — Info`, or `Toast — Neutral` roles. The color scheme
owns the surface, foreground, icon, and shadow source colors, including baked
shadow opacities. This component owns the shadow geometry below.

The surface has no visible border.

## Shadow

The Toast is a detached surface, so it uses the shared
[shadow character](../../foundation/shadow.md) with two component-owned layers.
Draw both behind the pill and clip neither layer.

| Layer            | Color role                   | Horizontal offset | Vertical offset | Blur | Spread |
| ---------------- | ---------------------------- | ----------------- | --------------- | ---- | ------ |
| Broad lower fade | `Toast.<status>.broadShadow` | `0`               | `18`            | `38` | `-8`   |
| Close separation | `Toast.<status>.closeShadow` | `0`               | `6`             | `12` | `4`    |

Render the broad lower fade first and the close separation above it. The layers
must merge into one quiet shadow rather than appearing as two outlines. Move,
scale, and dismiss the shadow with the surface as one object; do not animate the
shadow properties independently.

## Message lifetime

By default, calculate the visible lifetime from the trimmed message length:

```text
readable characters = max(1, trimmed message character count)
estimated milliseconds = round(readable characters / 14 × 1000)
visible lifetime = clamp(estimated milliseconds, 2500, 8000)
```

The lifetime starts when the Toast is presented, including its entrance. A
product may provide an explicit lifetime when the message requires a known
duration, but it must remain long enough to read at the supported text sizes.

Pause automatic dismissal while the software is inactive. When it becomes
active again, give the Toast its complete resolved lifetime anew. Contact with
the Toast does not restart the timer. If the lifetime ends while a finger
remains down, keep the Toast visible and dismiss it as soon as the finger
releases or the interaction is cancelled.

## Interaction and dismissal

The Toast dismisses through any of these paths:

- its visible lifetime ends;
- the person taps the surface;
- the person drags or swipes it upward far or fast enough; or
- another Toast replaces it.

A tap is recognized when contact ends without moving beyond the platform's tap
tolerance. Begin the pressed state on contact, dismiss on release, and consume
the interaction so the control underneath never receives the same tap.

The Toast has no downward, left, or right action. Those directions use the
shared [drag-resistance behavior](../drag-resistance.md) with a maximum offset
of `6` on each enabled axis.

| Direction | Behavior         | Maximum resistance offset |
| --------- | ---------------- | ------------------------- |
| Up        | Dismiss progress | `0`                       |
| Down      | Drag resistance  | `6`                       |
| Left      | Drag resistance  | `6`                       |
| Right     | Drag resistance  | `6`                       |

If an upward dismissal drag reverses, restore all dismissal progress before
downward resistance begins. Never combine dismissal movement and resistance on
the vertical axis at the same time.

## Upward drag

The Toast follows the finger during an upward drag. As the finger moves up, the
Toast moves toward the top of the screen and becomes less visible. It does not
wait until release to respond.

Use a visible-progress value that starts at `100%` when the Toast is resting:

1. Every `82` of upward movement reduces visible progress by `100` percentage
   points. Downward movement restores that progress.
2. Count no more than `24` from a single movement update. This prevents a late
   or unusually large input event from making the Toast jump.
3. While the finger remains down, keep visible progress between `24%` and
   `100%`. The Toast therefore remains partly visible until dismissal is
   decided.
4. Set opacity equal to visible progress. At `75%` progress, for example, the
   Toast uses `75%` opacity.
5. Move the Toast upward in the same proportion. At `75%` progress, it has
   travelled `25%` of the distance toward its dismissed position.

The dismissed position is `22%` of the presentation block's height above the
resting position. The presentation block includes the top safe-area inset,
`16` above the Toast, the Toast itself, and `16` below it.

For an implementation, the complete relationship is:

```text
counted change = clamp(vertical change, -24, 24)
visible progress = clamp(visible progress + counted change / 82, 0.24, 1)
opacity = visible progress
distance above rest = (1 - visible progress) × 22% of presentation block height
```

In this relationship, upward movement is negative and downward movement is
positive.

### On release

Dismiss the Toast when any of these is true:

- upward velocity is at least `250` logical units per second;
- accumulated upward distance is at least `12`; or
- visible progress is `34%` or lower.

If none is true, restore the Toast to `100%` visible progress. A clear downward
release always returns the Toast to rest.

## States

| State               | Observable behavior                                                         |
| ------------------- | --------------------------------------------------------------------------- |
| Entering            | The Toast moves and fades from its upper starting state to rest.            |
| Resting             | The Toast is fully visible while its lifetime continues.                    |
| Pressed             | The complete surface compresses slightly while contact remains.             |
| Dragging to dismiss | Upward movement controls position and opacity directly.                     |
| Resisting           | Downward or horizontal movement yields subtly without triggering an action. |
| Returning           | An incomplete upward drag restores the Toast to rest.                       |
| Dismissing          | The Toast moves toward its upper starting state while fading out.           |
| Replaced            | The current Toast is removed immediately before the next one enters.        |
| Removed             | The Toast no longer paints, receives input, or occupies the feedback layer. |

## Motion

The Toast follows the shared [animation foundation](../../foundation/animations.md)
with these exact component values:

### Entrance

- Duration: `280 ms`.
- Easing: cubic ease-out.
- Start at `0%` opacity and `22%` of the complete presentation block's height
  above its resting position.
- Finish at full opacity and the resting position.
- Animate the surface, content, and shadow as one object.

### Dismissal

- Duration: `220 ms`.
- Easing: cubic ease-out.
- Reverse the entrance path: move upward to `22%` of the presentation block's
  height above rest while fading to `0%` opacity.
- Start from the Toast's current visible progress when dismissal follows a drag.

### Return from an incomplete upward drag

- Duration: `280 ms`.
- Easing: cubic ease-out.
- Animate from the current progress to the fully visible resting state.
- Do not jump to the entrance start or replay the complete entrance.

### Press feedback

- Scale the complete Toast from `100%` to `98.5%` over `300 ms` with a cubic
  ease-out.
- Keep the top-left corner fixed while scaling.
- Return to `100%` over `300 ms` with the same easing after release or
  cancellation.
- Do not change opacity, color, radius, or shadow independently for the pressed
  state.

Resistance returns according to the shared drag-resistance timing. Every motion
path must remain interruptible and continue from the currently visible state.

## Reduced motion

When the phone requests reduced motion:

- present the Toast fully visible in its resting position immediately;
- remove automatic entrance, return, exit, and press-scale animation;
- keep tap, upward-drag, timed, and replacement dismissal available;
- keep drag resistance at zero; and
- apply the final visible or removed state immediately after the interaction.

The message lifetime, layering, colors, geometry, and accessibility announcement
remain unchanged.

## Accessibility and localization

- Announce every Toast with the platform's native, non-interrupting live-status
  behavior when it appears.
- Use the complete localized message as its accessibility label, including text
  hidden by the two-line visual limit.
- Do not move screen-reader focus into the Toast or interrupt the current task.
- Hide the status icon from assistive technologies so it is not announced in
  addition to the complete message.
- Express the outcome in the message itself. Keep the icon as a visual
  reinforcement and never rely on color alone.
- Preserve text scaling. Recalculate the Toast's height and pill radius from the
  scaled message instead of clipping vertically.
- Mirror icon and message order for right-to-left languages.
- Do not require a swipe to dismiss; tap and automatic dismissal remain
  available.
- Do not place essential instructions, irreversible outcomes, or the only copy
  of an error inside a transient Toast.
- Do not give Error or Warning an interruptive announcement merely because of
  its status. Information important or time-sensitive enough to interrupt the
  person requires a more persistent or interruptive component.

The Toast emits no haptic feedback or sound by default. A product must not add
either merely because the Toast appears.

## Validation

A Toast is ready when:

- Error, Warning, Info, and Success use their defined default icons unless a
  more specific icon is supplied;
- Neutral cannot be presented without a relevant custom icon;
- every status resolves its surface, foreground, icon, and shadow colors from
  the matching mobile color-scheme roles;
- one- and two-line messages match the defined geometry without changing the
  icon size or gap;
- longer text truncates visually after two lines while the full message remains
  available to assistive technologies;
- the pill and complete shadow remain visible over plain and visually varied
  backgrounds;
- the Toast stays above navigation and shared-element transitions;
- a new Toast replaces the current one instead of stacking;
- tapping dismisses without activating content underneath;
- upward dragging follows the finger, commits at the defined thresholds, and
  returns cleanly when incomplete;
- downward and horizontal pulls use resistance without suggesting dismissal;
- holding the Toast prevents a timed dismissal until release;
- inactive software does not consume the message lifetime;
- assistive technologies announce the complete message without moving focus or
  announcing the status icon separately;
- reduced motion preserves every dismissal path without movement; and
- entrance, press, drag, return, and exit remain smooth on the least capable
  supported phone.

Review the Toast at normal speed and frame by frame. Validate short, two-line,
truncated, localized, right-to-left, large-text, custom-icon, reduced-motion,
replacement, and visually busy-background states on both iOS and Android
phones.

Keep the message direct and specific. State what happened in language the person
can act on without adding a title or explanation paragraph.
