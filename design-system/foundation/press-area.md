# Press area — Mateo Design System

A press area is the complete region that activates an interactive object. It
may be larger than the object's visible shape so the interface remains
forgiving when a person presses near, rather than exactly on, what they intend
to use.

This foundation owns Mateo's shared press-area behavior. Guidance is added as
each part of that behavior is defined. The current guidance covers only how
neighboring interactive objects share the spacing between them.

In this foundation, **press** includes touch, mouse, trackpad, stylus, and other
direct pointer activation. Platform accessibility actions and keyboard
activation still operate on the same interactive object, but they do not
change how pointer space is divided.

## Shared spacing in a list

When interactive objects are arranged as neighboring items in a vertical or
horizontal list, the visual spacing between them must not become an
unresponsive gap. Divide that spacing equally between the two neighboring
press areas:

- the first half belongs to the item before the gap;
- the second half belongs to the item after the gap; and
- the boundary between them sits at the exact midpoint of the visual gap.

For example, if two options have `20` density-independent units of visible
space between them, extend the first option's press area `10` units into the
gap and extend the second option's press area `10` units into the gap. The
visible objects do not move, grow, or paint into that space.

This creates one continuous interactive region across the list. A press that
lands slightly outside an item is therefore likely to activate the item the
person intended instead of doing nothing.

Apply the rule along the list's main axis:

- in a vertical list, the upper half of a gap belongs to the item above and the
  lower half belongs to the item below;
- in a horizontal list, the leading half belongs to the item before the gap
  and the trailing half belongs to the item after it; and
- in right-to-left layouts, leading and trailing follow the resolved reading
  direction.

If the gap cannot be represented as two equal physical-pixel regions, place
the press boundary at its geometric midpoint and let the platform resolve that
boundary to physical pixels. There must be no unresponsive strip and no
overlapping region in which both items can activate.

## Interaction ownership

The shared spacing remains part of its neighboring items. It must not become a
separate interactive object, focus stop, accessibility node, or visual state.

When a person presses within a shared half-gap:

- activate the item that owns that half;
- apply that item's normal press feedback;
- expose the same label, role, state, and action as pressing its visible
  content; and
- preserve the component's normal selection, callback, dismissal, and motion
  behavior.

Where the platform exposes spatial accessibility bounds, include the owned
half-gap in the item's bounds so accessibility geometry and pointer behavior
describe the same target. Neighboring accessibility bounds must remain
distinct and must not overlap.

## Boundaries and exceptions

Share only spacing between interactive siblings that belong to the same list
or choice group. Do not automatically assign these regions to an item:

- padding between the list and its containing surface;
- spacing that separates different sections or groups;
- scrolling gutters, safe areas, or system gesture regions;
- space reserved for another control; or
- a gap whose component specification intentionally dismisses, deselects, or
  performs another action.

If a separator sits between two items, it remains visual and non-interactive;
the surrounding press space still divides at the midpoint between the items.
The separator must not create dead space.

Expanding a press area must not change the visible position or size of an item.
It must also preserve layout and animation geometry: transitions align to the
visible object while hit testing uses the larger press area.

## Validation

A list follows this foundation when:

- every point in the visual spacing between neighboring interactive items
  belongs to exactly one of those items;
- the midpoint divides the gap equally;
- pressing either half activates its owning item and shows that item's normal
  feedback;
- no invisible focus stop or accessibility node is introduced;
- pointer and spatial accessibility bounds agree without overlapping;
- the visible spacing, alignment, and motion geometry remain unchanged; and
- container padding and boundaries between unrelated groups keep their
  component-defined behavior.
