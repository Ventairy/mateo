# Loading — Mateo Design System

Loading feedback tells a person that the interface received their request,
what part is waiting, and whether useful content can already be used. It must
never pretend to know more about the result than the system actually knows.
It does not make preventable waiting acceptable; real performance remains the
priority.

Mateo uses three loading primitives:

| What is known before loading completes                                    | Primitive          | What it communicates                                             |
| ------------------------------------------------------------------------- | ------------------ | ---------------------------------------------------------------- |
| The final content structure and placement                                 | Animated skeleton  | This exact structure is being filled with content.               |
| The operation is active, but its result or structure is not known         | Loading indicator  | Work is continuing without predicting what will appear.          |
| The final visual frame is known, but the image or visual contents are not | Visual placeholder | This area is reserved for visual content that is still arriving. |

Choose the primitive from what is genuinely known. Do not select one only
because it is visually convenient.

This foundation defines how the primitives behave and how to choose between
them. It does not define shared dimensions, colors, durations, or easing
curves. Each component or platform specification owns those values and must
follow the [animation foundation](animations.md).

## Animated skeleton

Use an animated skeleton when the final content has a predictable structure
and will replace the skeleton in the same location. This includes an initial
page whose layout is already known, a known card or list row, and an individual
content region with a stable final composition.

A skeleton is a simplified rendering of the final layout, not a generic group
of gray bars. It must preserve:

- the final region's outer size and placement;
- the number and order of its meaningful content areas;
- the approximate width and height of text lines;
- the size, shape, and placement of media, icons, and controls; and
- the spacing and alignment relationships that will remain after loading.

The replacement content must fit the reserved layout without pushing nearby
content. Small variations caused by real text are acceptable, but a skeleton
must not promise a substantially different number of rows, image proportion,
or information density.

Skeleton shapes are neutral and non-semantic. Preserve the final component's
recognizable geometry while removing readable text, icons, imagery, and
interactive styling. Text bones use deeply rounded or pill-shaped lines;
containers and media areas follow the geometry defined by their component and
the [border-radius foundation](border-radius.md).

Animate the skeleton in normal motion settings so it cannot be mistaken for
disabled or already loaded content. Use one restrained, continuous effect
across a connected skeleton region, such as a soft highlight sweep or gentle
opacity cycle. The animation must have no visible jump, blank frame, or pause
at the loop boundary. It signals activity; it does not attempt to entertain.

Do not use a skeleton when:

- the final structure is unknown or highly variable;
- the result commonly resolves to one of several unrelated layouts;
- existing content remains usable while it refreshes;
- an action is running inside a control; or
- more items are being appended to content that is already visible.

In those cases, use a loading indicator or visual placeholder as appropriate.

## Loading indicators

Use a loading indicator when work is active but showing the shape of its result
would be misleading. Indicators are the default for actions and incremental
work, including:

- a button submitting or saving an action;
- an operation whose result is not yet known;
- loading more items at the end of a list;
- refreshing existing content while it remains visible; and
- a compact region that cannot meaningfully preview its result.

Place the indicator at the source or boundary of the work. A button indicator
stays inside the button. An appended-list indicator stays after the last
available item. A region-level indicator stays inside that region. Do not
replace the whole page when only one local part is waiting.

Preserve the loading control's size so surrounding layout does not move. Keep
enough of its label or accessible name to identify the action, and prevent
unsafe repeated activation while the action is pending. Unrelated controls
should remain available unless the operation truly makes them unsafe.

### Indeterminate indicators

Use an indeterminate indicator when completion cannot be measured honestly.
Mateo may express this with sequential dots, a circular activity indicator, or
another component-specific loop. The motion must be continuous and clearly
active without suggesting a percentage or finish time.

Choose the form that fits the available space and component character. Dot
motion can feel warm and expressive in a compact Mateo surface. A circular
indicator is appropriate when space is constrained or the platform already
uses that form consistently. Do not combine several indeterminate indicators
for the same operation.

### Determinate indicators

Use a determinate indicator when the system has trustworthy progress. Expose
the actual completed proportion and update it as work advances. Progress must
never move backward unless the underlying task genuinely does, and it must not
race to an invented near-complete value while most of the wait remains.

If an operation begins indeterminate and later becomes measurable, it may
become determinate without changing its occupied geometry or creating a second
loading surface. If reliable progress is lost, return to an indeterminate
state without changing the indicator's footprint. Retain the last value only
when the task is genuinely paused, and explain that state. Do not change the
indicator's visual form merely because its progress becomes measurable.

For a long operation, add short, specific status text when it gives useful
information beyond the animation. Offer cancel or pause only when the operation
can support it safely, and explain when stopping would discard progress.

## Visual placeholders

Use a visual placeholder when the final frame is known but its internal content
cannot be predicted. Typical examples are images, maps before their first
usable frame, previews, and square or rectangular media areas whose content is
still arriving.

The placeholder reserves the exact final width, height, outer shape, and
position. It does not imitate details that may not exist. Mateo's default
expression is an animated dot matrix over a skeleton-colored placeholder
surface:

- the matrix fills the reserved visual frame;
- its outer boundary follows the final frame's shape;
- dots form an even field without overlap;
- a soft area of emphasis moves continuously through neighboring dots;
- dots become more visible as the emphasis approaches and return smoothly as
  it leaves; and
- the loop has no obvious restart or abrupt change of direction.

The matrix communicates that an unknown visual is coming while keeping the
area distinctly Mateo. It is not a miniature preview of the final image or
map. Do not add fake image lines, map roads, pins, or other guessed content.

Within a known page skeleton, use visual placeholders for unknown media slots
while the surrounding text and layout use skeleton bones. Each primitive then
describes a different region truthfully.

Replace the placeholder when the visual is usable, not only when every
background resource has finished. For example, a map may appear after its
first stable interactive frame while additional detail continues loading.

If a previously loaded image or visual remains valid during refresh, keep it
visible and show local loading feedback instead of replacing it with the
placeholder. If loading fails, replace the placeholder with the component's
error state and recovery action; do not leave an animation running
indefinitely.

## Loading behavior

Loading is one state in a complete result model:

1. **Waiting:** show the correct primitive only in the region that is pending.
2. **Available:** replace each pending region as soon as its content is usable.
3. **Empty:** show the intentional empty state, never a finished skeleton or indicator.
4. **Failed:** stop loading feedback and show an actionable error state.

Do not hold already available content until every request finishes. Reveal
independent regions progressively when doing so preserves a stable reading and
interaction order. Keep existing content visible during refresh, pagination,
and background synchronization whenever it is still valid.

Loading feedback must appear promptly enough that a blank or frozen interface
is never mistaken for failure. A component may avoid showing a loader for an
operation that completes almost immediately only when useful content or direct
press feedback remains visible during that time. Never delay real content to
meet an animation or minimum display time.

When content replaces a skeleton or placeholder, preserve the same outer
bounds and align the two states exactly. Use an immediate replacement or a
short, coordinated opacity handoff. Do not animate every loaded child as a
separate entrance, and do not leave readable content overlapping its loading
state.

One pending region should have one primary loading signal. Do not place a
spinner over a skeleton, pair dots with a circular indicator, or show both a
page loader and a local loader for the same region. The dot matrix and its base
surface are one visual-placeholder primitive, not competing signals.

## Accessibility

Loading must remain understandable without seeing its color or animation.

- Mark the affected region as busy using the platform's accessibility
  semantics, and clear that state as soon as the region becomes available,
  empty, or failed.
- Give an indicator an accessible name that identifies the operation or
  content being loaded. A generic repeated announcement of “loading” is not
  enough when several regions can load independently.
- Expose the current value, minimum, and maximum for determinate progress. Do
  not expose an invented value for indeterminate progress.
- Treat skeleton bones, shimmer, matrix dots, and other decorative parts as one
  loading representation. They must not become separate focus targets or be
  announced individually.
- Announce meaningful state changes without announcing every animation cycle
  or progress update. Completion, failure, and a significant change in status
  matter; each painted frame does not.
- Preserve focus and reading position while content loads. A replacement must
  not steal focus unless the completed navigation or action explicitly
  requires it.
- Keep the pending control's accessible name meaningful, such as the action in
  progress, rather than replacing it with an unlabeled indicator.

When reduced motion is requested, stop the skeleton, indicator, and matrix
loops. Keep a visible static loading representation and the same accessibility
status so the interface never appears finished or disabled by mistake.

## Performance

Loading animation runs while the interface is already doing expensive work, so
it must use very little of the remaining frame budget.

- Use one animation source for a connected skeleton, dot sequence, or matrix
  instead of one independent animation per shape.
- Keep per-frame work limited to painting or compositing whenever the same
  visible result can be produced without repeated layout.
- Avoid blur, large off-screen layers, and effects that repaint unrelated
  content.
- Pause loops when their loading region is offscreen, fully obscured, or the
  software is inactive.
- Stop and release animation work immediately when loading ends.
- Verify on the least capable supported device while the real loading work is
  happening, not only with an idle animation preview.

## Component loading contract

Every component that can load must define:

- which of the three primitives it uses and why the result is known or unknown;
- the exact loading region, reserved geometry, and replacement alignment;
- the animation's duration, easing, path, opacity range, and loop behavior;
- whether progress is determinate or indeterminate and where its data comes
  from;
- how existing content, controls, focus, and interaction behave while pending;
- how loading begins, completes, refreshes, appends, cancels, times out, and
  fails;
- the empty and error states that replace loading;
- the accessible name, busy state, progress semantics, and announcements;
- the reduced-motion representation; and
- the performance states used to validate the result.

## Validation

A Mateo loading state is complete when:

- the chosen primitive truthfully matches what is known about the result;
- a skeleton reproduces the final structure closely enough to avoid a visible
  layout jump;
- a visual placeholder preserves the final media frame without guessing its
  contents;
- an indicator sits at the source or boundary of its operation;
- useful existing content and unrelated actions remain available;
- progress values are accurate and indeterminate work shows no false estimate;
- the animation loops smoothly, pauses when invisible, and stops when complete;
- reduced motion retains an unmistakable static loading state;
- assistive technology receives one clear loading state and the correct final
  result; and
- empty, failure, cancellation, and repeated loading cannot leave the
  interface blank, blocked, or permanently busy.
