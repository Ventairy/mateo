# Action Bloom — Mateo Design System

Action Bloom lets one clear action reveal the small set of related choices
needed to complete it. The source button does not disappear and summon an
unrelated menu. Its surface expands into the choices, preserving the feeling
that the person is still acting through the same control.

Use Action Bloom primarily when the intent is already clear but its final form
is not. “Proceed with payment” may bloom into payment methods. “Post” may bloom
into the available destinations or audiences. It may also hold a compact set
of closely related commands when keeping several permanent buttons visible
would obscure the main task.

Action Bloom follows Mateo's [animation](animations.md) and
[border-radius](border-radius.md) foundations. This document owns the shared
interaction and continuity rules. Each platform specification owns the final
surface, placement, dimensions, motion values, input behavior, and
accessibility API.

## Purpose and non-purpose

Use Action Bloom when:

- the source button names one understandable intent;
- every revealed action directly completes or qualifies that intent;
- comparing the choices together helps the person decide; and
- the set is small enough to understand at a glance.

Do not use Action Bloom for one action. Perform that action directly.

Do not use it as primary navigation, a replacement for a selection field, a
long list of unrelated commands, or a multi-step workflow. Use the platform's
menu, picker, sheet, dialog, or full view when the task needs hierarchy,
search, persistent selection, data entry, confirmation, or several steps.

## Anatomy

1. **Source action:** the resting button or compact action surface that names
   the shared intent.
2. **Bloom surface:** the source surface while it expands and contains the
   choices.
3. **Action collection:** the complete set of available actions revealed by
   the bloom.
4. **Action:** one choice with a required title and any platform-defined
   supporting content.
5. **Dismissal region:** the platform-appropriate area or command that closes
   the bloom without selecting an action.

The source action and bloom surface are two states of one component. Do not
draw a second surface over the source while leaving the source visibly behind.

## Choosing actions

An Action Bloom contains at least two actions. Two to five is the normal range.
This is guidance rather than a universal maximum: a platform may support more
when the choices remain easy to compare and the platform specification defines
how they fit. If the list becomes something the person must browse, search, or
organize, use a component designed for that task.

Every action must:

- complete, qualify, or directly relate to the source intent;
- use a concise title that says what choosing it will do;
- remain understandable without relying on color;
- be distinct from the other actions; and
- be available when the bloom opens.

Add supporting text only when the title cannot safely explain the consequence
or the difference between similar choices. Do not repeat the title in longer
words.

Order actions by expected usefulness and task flow. Keep choices that people
compare next to each other. Place an irreversible or destructive action where
it cannot be mistaken for the routine path, and name its consequence
explicitly. Use the platform's confirmation pattern when the consequence
cannot be safely undone; do not turn the bloom itself into a confirmation
workflow.

## States

| State      | Shared behavior                                                                                                 |
| ---------- | --------------------------------------------------------------------------------------------------------------- |
| Closed     | The source action is visible, interactive, and the only Action Bloom surface exposed to assistive technology.   |
| Opening    | The source surface expands continuously toward the platform destination while the choices become present.       |
| Open       | The complete action collection is readable and interactive, and the underlying task cannot receive input.       |
| Choosing   | One action receives feedback, the bloom begins closing, and repeated activation cannot choose it a second time. |
| Dismissing | The bloom returns toward the source without invoking an action.                                                 |
| Restored   | The original source action is visible again and interaction focus returns to the context that opened the bloom. |

Opening and closing must remain interruptible. If the environment changes
during the transition, continue from the current visible state or settle
immediately into the correct state. Never restart from a hidden initial frame.

## Surface continuity

Begin the bloom at the source action's exact rendered bounds, shape, surface
color, border, clipping, and visual origin. Transform that same visible
boundary into the platform's open surface. The source must not blink out,
jump to a different position, become square midway, or leave a duplicate
behind.

Reveal the action collection only after the expanding surface is established
enough to contain it. Keep the content clipped to the moving boundary. The
collection may fade or move with the surface, but it must not look like a
separate menu arriving from another origin.

Cancellation reverses the spatial story. Return to the exact source bounds
and restore the source action only when the closing surface reaches it.
Selection also closes the bloom, but the chosen action may continue according
to the platform's feedback and navigation conventions.

## Interaction and dismissal

Opening the source action must produce immediate feedback. While the surface is
still transforming, prevent accidental selection until the platform defines
the choices as ready for input.

Choosing an action:

1. gives the chosen action its normal platform feedback;
2. prevents a second choice;
3. starts closing the bloom; and
4. performs the action without reopening or replacing the bloom.

Every implementation must provide a visible or platform-familiar way to
dismiss without choosing. It must also support the platform back, cancel, or
escape command and the assistive-technology dismiss action where those exist.
Do not require a precision gesture to close the bloom.

## Motion and reduced motion

The expansion communicates continuity and state change, so it must preserve a
clear source and destination rather than behave like decorative scale.
Coordinate bounds, shape, color, clipping, border, backdrop, and content as one
transition. Each platform owns the exact duration and easing required by its
size and input model.

When reduced motion is requested, present and dismiss the final states without
spatial transformation. Preserve the same choices, modal boundary, focus
behavior, action feedback, and dismissal methods. Reduced motion changes how
the state appears, not what the component does.

## Accessibility

- Give the source action a complete accessible name. An icon alone is never
  its accessible name.
- Communicate that activating the source reveals additional choices through
  the platform's expandable-control semantics.
- When open, expose the action collection as one new interaction context and
  prevent the underlying interface from competing in the reading or focus
  order.
- Give every action a full accessible title. Expose supporting text even when
  the visible text must truncate.
- Move interaction focus into the open context, then restore the previous
  focus when the bloom closes.
- Provide an accessible dismissal action and keep platform back or cancel
  behavior available.
- Preserve logical action order in left-to-right and right-to-left languages.
- Do not rely on surface color, icon color, or motion to distinguish choices
  or consequences.

## Platform contract

A platform specification for Action Bloom must define:

- supported source controls and input methods;
- destination placement, size, shape, layering, and safe-boundary behavior;
- action anatomy, spacing, typography, colors, limits, and overflow;
- exact opening, closing, content, backdrop, and reduced-motion behavior;
- when the open collection begins accepting input;
- selection, cancellation, interruption, and focus restoration;
- localization, text scaling, and assistive-technology behavior; and
- validation for the platform's supported window and device configurations.

## Good and bad use

| Good use                                                        | Avoid                                                         |
| --------------------------------------------------------------- | ------------------------------------------------------------- |
| “Proceed with payment” → Card, Pix, or bank transfer            | “Proceed” → Payment, Help, Settings, and Sign out             |
| “Post” → Feed, Story, or selected community                     | Opening a full post editor with several required fields       |
| “Create” → Note, folder, or reminder                            | A single “Create note” choice                                 |
| A compact set of actions for the object represented by a button | Primary app navigation or a long catalog of object operations |
