# Animation — Mateo Design System

Animation makes Mateo interfaces feel direct, continuous, and alive. It shows
that an action was received, explains how the interface changed, and keeps a
person oriented as elements move between states.

Motion is not decoration added after a component is designed. It is part of the
component's behavior, alongside layout, color, shape, and interaction. When an
animation cannot explain something useful, the correct animation is no
animation.

This foundation defines Mateo's motion character and the primitives used to
create it. It intentionally defines no shared durations, distances, curves,
springs, or gesture thresholds. Those values depend on the component, its size,
its platform, and how often the interaction occurs. Each component owns the
exact values required to reproduce its motion.

## Motion character

Mateo motion is:

- **Immediate.** Feedback begins with the interaction. A press responds when
  contact begins, and a draggable element moves with the person's input.
- **Continuous.** The interface moves from its current visible state to the
  next one. It never jumps back to the start of an animation or waits for an
  earlier transition to finish.
- **Physical.** Movement has a clear origin, direction, weight, and resting
  place. Gestures carry their direction and momentum into the result.
- **Smooth.** Speed changes gradually, coordinated properties arrive together,
  and no frame reveals an unintended pause or hard stop.
- **Restrained.** Frequent actions use less motion. Expressive motion is saved
  for moments where it improves understanding or makes an uncommon interaction
  feel rewarding.
- **Warm.** Small scale changes, soft settling, continuity, and well-timed
  feedback make the interface feel responsive and human without becoming
  theatrical.

## The purpose gate

Every animation must have at least one clear purpose:

| Purpose                        | What the animation communicates                                                 |
| ------------------------------ | ------------------------------------------------------------------------------- |
| Feedback                       | The interface received a press, drag, choice, or command.                       |
| State change                   | A component moved from one meaningful state to another.                         |
| Continuity                     | The same content or surface persists while its form, position, or size changes. |
| Spatial orientation            | Where something came from, where it went, or how two views are related.         |
| Progress                       | Work is active, advancing, or waiting for completion.                           |
| Prevention of a jarring change | Content would otherwise appear, disappear, resize, or reorder abruptly.         |
| Delight                        | An uncommon moment gains warmth or personality without delaying the task.       |

Reject animation when its only purpose is to attract attention, make a common
action look impressive, or fill time. Do not animate stable information merely
because it can move.

Frequency changes the answer. Motion seen repeatedly must become shorter,
smaller, and quieter until it is effectively immediate. Occasional surfaces and
rare moments can carry more visible continuity or delight. No animation may
make an experienced person wait for an action they perform often.

## Motion primitives

Components build their animations from the following primitives. Use the
smallest combination that explains the change.

### Translation

Translation communicates direction and spatial relationship. Move an element
from the place it belongs outside the current state toward its resting place.
An exiting element should normally return along the path that introduced it.

Distance must match the spatial story. A surface entering from beyond a screen
edge may travel farther than content changing inside an existing container.
Avoid arbitrary movement that has no relationship to a source, destination, or
gesture.

### Scale

Scale communicates contact, depth, and a change in physical presence. Press
feedback may compress a control slightly. A surface may grow gently as it
arrives when that growth reinforces its origin or depth.

Never introduce a complete interface element from zero scale. It should begin
as a recognizable version of itself, not appear from nothing. Keep text,
icons, clipping, shadow, and touch feedback attached to the same scaling
surface.

### Opacity

Opacity softens entrances, exits, and content replacement. Pair it with spatial
or shape continuity when location matters. A fade alone is suitable when the
before and after states occupy the same place and no directional relationship
needs explanation.

Do not leave two readable states visibly overlapping during a crossfade. Tune
their timing or briefly soften the overlap so the change reads as one coherent
transition.

### Rotation

Rotation communicates orientation, progress around an axis, or momentum. It
must rotate around the point that would physically hold the element. Avoid
rotation as a generic entrance effect.

### Shape and clipping

Shape transitions preserve identity when one surface becomes another. Animate
the complete visible boundary continuously, including its background, content
clipping, touch feedback, and shadow. Follow the
[border-radius foundation](border-radius.md) throughout the transition.

Clipping and masks may reveal content without moving its layout. Their movement
must follow the same origin and direction rules as translation.

### Time

Duration expresses distance, size, frequency, and consequence. A small or
frequent response should settle sooner than a large surface travelling across
the screen. A deliberate action may take longer while the person is deciding;
the system's confirmation should respond quickly.

Duration is measured by perceived completion, not merely by when an animation
system reports that it has stopped. Long, barely visible settling must not keep
input blocked or make a component feel unfinished.

### Easing

Easing defines how motion gains and loses speed.

- Use an ease-out character for responses, entrances, exits, and returns. It
  reacts immediately and settles gently.
- Use an ease-in-out character when an element already on screen moves between
  two equally visible positions or forms.
- Use linear motion only when constant speed is itself meaningful, such as the
  phase of a continuous progress loop.
- Avoid ease-in motion for direct interface responses. Its slow beginning makes
  the interface feel late.

A component must define its exact curves and explain which phase uses each one.
Do not choose a curve in isolation from duration and distance; they create one
perceived movement together.

### Springs

Springs are behavior, not decorative bounce. Use them for gesture-driven or
rapidly retargeted movement where the animation must preserve velocity and
remain interruptible.

Start with a controlled settle without visible oscillation. Add overshoot only
when momentum from the person's gesture makes it physically believable or when
an uncommon, expressive moment deliberately earns it. Ordinary entrances,
menus, and repeated controls should not bounce.

Each spring-driven component must define the parameters used by its platform,
the intended perceptual completion, whether overshoot is allowed, and how
release velocity enters the spring.

## Interaction and direct manipulation

The person and the interface must appear connected during an interaction.

- Begin press feedback when contact starts, not after activation completes.
- During a valid drag, keep the component attached to the person's finger,
  pointer, or stylus and preserve the point where it was grabbed.
- When movement has a real action, let the gesture control the animation's
  progress directly.
- When movement reaches a boundary with no action, use the shared
  [drag-resistance behavior](../mobile/drag-resistance.md) instead of an
  invisible wall.
- On release, use direction, distance, and velocity to decide whether the
  interaction completes or returns.
- Continue from the release velocity when the component settles. Do not create
  a visible seam between the finger-driven and system-driven phases.
- Allow a moving component to be grabbed, reversed, or retargeted from its
  current visible position.
- Ignore additional contact points once a single-contact gesture owns the
  component, unless multi-touch is an intentional part of that component.

Gesture thresholds, supported directions, resistance distance, commit rules,
and release behavior belong to the component specification. They must prevent
accidental activation without making the interface feel disconnected from the
finger.

## Entrances and exits

An entrance answers where the element came from and why it is now present. An
exit answers where it went.

- Give the surface a stable visible destination before choosing its starting
  state.
- Derive the starting position and transform origin from the trigger, screen
  edge, parent surface, or navigation direction that created it.
- Keep enter and exit paths spatially consistent.
- Begin without artificial delay after the triggering action.
- Let exits finish promptly once the person has decided to dismiss something.
- Remove an exiting element only after its visible exit completes, unless
  reduced motion requires an immediate state change.

When several elements form one component, animate the component as one object
first. Sequence internal parts only when their order explains hierarchy or
cause and effect. Decorative staggering must never delay interaction.

## State, content, and layout changes

Prefer continuity over replacement. If a surface changes purpose, size, or
content, preserve the existing surface and animate toward the destination state
instead of closing it and opening a second one.

Keep stable elements stable. Animate only the parts that actually changed.
When geometry changes, preserve the edge or origin that gives the component its
spatial identity. Coordinate content and container motion so outgoing content
is not clipped and incoming content does not appear before space exists for it.

Layout animation is allowed when changing geometry is the information being
communicated. Isolate the change to the smallest visible region and ensure it
remains smooth on the least capable supported device. Prefer motion techniques
that avoid recalculating surrounding layout when they can reproduce the same
visible result.

## Shared element transitions

A shared element transition preserves one meaningful element across a change of
screen. Instead of making the source disappear and the destination appear, the
element moves and reshapes from its source bounds into its destination bounds.
This makes the destination feel like a continuation of the action that opened
it.

Use this transition when all of the following are true:

- The source and destination represent the same content, object, or action, not
  merely two elements that look alike.
- The element is visible in the source screen before navigation and visible in
  the destination screen after navigation.
- Keeping the element in view helps explain how the two screens are related.
- The movement follows a direct path that the eye can track without searching
  or crossing through unrelated parts of the interface.
- The two endpoint designs can transform without making text, imagery, shape,
  or controls look broken.

A card title that remains the title of the opened screen is a strong shared
element. The same is true for an image, button, or surface that keeps its
identity after navigation. Reusing a visual style is not enough: two unrelated
buttons with the same appearance are not one shared element.

### Travel distance

There is no fixed distance limit. Judge distance in relation to the element's
size, the screen, the path, and the surrounding content.

Use the transition when the movement feels local and connected. An element may
move several times its own height and still read clearly when the path is
direct and remains within the same visual region. For example, a control about
`50 px` high moving roughly `200 px` can still feel close; this is an example,
not a threshold.

Do not use it when the element appears to tour the interface rather than move
to a nearby destination. Moving a control from the top of the screen to the
bottom, crossing most of the screen diagonally, or passing through unrelated
content usually creates distraction instead of continuity. In those cases,
let the screen transition normally and reveal the destination element in
place.

Use these questions in review:

- Can the eye follow the element without scanning for where it landed?
- Does the path stay clear of unrelated controls and readable content?
- Does the movement explain the navigation, or does it dominate it?
- Does the element still feel like the same object at every point?

If any answer is unclear, do not share the element.

### Endpoint matching

Give each source and destination pair one stable, unique identity. Repeated
items must use the identity of their data, not their position in a list. A
screen must never contain two visible candidates with the same shared
identity.

Resolve both endpoint layouts before the transition begins. The moving element
must start at the exact visible source bounds and land at the exact visible
destination bounds. If either endpoint is absent, hidden, not yet laid out, or
no longer represents the same item, skip the shared movement and complete the
navigation with its normal transition. Motion is an enhancement; it must never
delay or prevent navigation while waiting for data or layout.

### How it moves

During navigation, render one moving visual representation of the shared
element above the outgoing and incoming screen content. Hide its stationary
copies for the duration of the movement so the person never sees a duplicate,
then reveal only the destination copy when the transition settles.

Interpolate the properties that preserve identity:

- position and visible bounds;
- size and scale;
- corner shape and clipping;
- background, border, and shadow when they belong to the element;
- image crop when the same image changes frame; and
- typography and line layout when the same text changes presentation.

Properties must tell one spatial story and reach their destination together.
Do not stretch imagery to a new aspect ratio; preserve its proportions and
change the crop or visible mask. Do not let text repeatedly reflow during the
transition. Keep one readable layout while it moves, or make a deliberate
single handoff between endpoint layouts when continuous interpolation cannot
remain legible.

The moving element normally sits above both screens so parent clipping or
opacity cannot cut it off. Preserve intentional masks when clipping is part of
the element itself. Persistent navigation and transient feedback such as
toasts must remain above the moving element when their visibility is still
required.

Animate only the smallest set of elements needed to preserve context. A
primary image and title may move independently when both clearly persist. When
several parts form one inseparable surface, move them as one group and preserve
their relative arrangement. Sharing many unrelated children turns the
transition into choreography and weakens the visual anchor.

### Navigation behavior

Forward and backward navigation must connect the same endpoints. Returning
should send the element back to the source that opened it, provided that source
still exists and is visible. If it does not, use the normal return transition.

When navigation progress is controlled by a gesture, the shared element must
follow that progress, reverse without a jump when the gesture is cancelled,
and continue from its current visible state when committed. A new navigation
or state change must either retarget the active transition safely or settle it
before taking ownership; two independent animations must never control the
same element at once.

The component or navigation pattern owns the exact duration, easing, path, and
property interpolation. Shared movement should begin with navigation, remain
short enough that it never delays the destination, and coordinate with the
rest of the screen transition rather than running on top of an unrelated route
animation.

For reduced motion, remove the spatial movement. Apply the destination
immediately or use a restrained opacity transition while preserving the same
navigation, content, focus destination, and final layout.

The moving visual is not a second accessible control. Expose only the
active screen's semantics, transfer focus to the destination when navigation
settles, and do not announce the same element twice during the transition.

## Continuous and loading motion

Loops communicate ongoing activity or a deliberately alive state. They demand
more restraint because they consume attention for as long as they run.

- Give every loop a readable rhythm with no visible reset, landing plateau, or
  frozen frame.
- Keep continuous movement away from content the person is trying to read.
- Use one coordinated animation source when several repeated parts form one
  effect.
- Pause loops when they are not visible, are obscured, or the software is not
  active.
- Stop the loop as soon as its state is no longer true.

A loading animation communicates that work continues; it must never hide an
indefinite failure or delay useful content for choreography.

## Coordinating motion, haptics, and sound

Visual motion, haptic feedback, and sound should describe the same event. Fire
them at the moment the action becomes true: contact, commit, snap, completion,
warning, or error.

Use haptics and sound sparingly. They belong to meaningful physical or semantic
moments, not every intermediate frame. Their intensity and rhythm must match
the movement, and disabling either must not make the interaction unclear.

## Reduced motion

Respect the platform's reduced-motion preference in every animated component.
The alternative must preserve state, feedback, reading order, and the final
layout while removing movement that can cause discomfort.

Depending on the component, reduced motion may:

- apply the destination immediately;
- replace translation, scale, rotation, parallax, or spring motion with a
  restrained opacity or color transition;
- show a stable loading or progress representation; or
- keep direct manipulation functional while removing decorative follow-through.

Reduced motion must not delay input, remove an available action, leave content
hidden, or become the only path with different semantics. Motion must never be
the sole way a component communicates status or meaning.

Avoid flashing, rapid brightness changes, and large continuous movement. Give
assistive technologies the resulting semantic state rather than attempting to
describe the animation itself.

## Performance

Smooth motion is part of correctness. An animation that drops frames does not
meet the Mateo standard even if its first and last frames are correct.

- Prefer changes to position, scale, rotation, and opacity that the intended
  platform can render efficiently without recalculating the full interface.
- Keep animation work local to the smallest visible region whose state changes.
- Use the intended platform's rendering-isolation and compositing capabilities
  only when they improve repeated movement without creating excessive layers
  or memory cost.
- Avoid expensive blur, shadow, clipping, or intermediate rendering effects
  during motion unless they materially improve the result and remain smooth.
- Keep a floating surface and its [shadow](shadow.md) attached to the same
  movement so they behave as one object.
- Pause animation work whenever its result cannot be seen.
- Never wait for an animation before beginning real work. When navigation or a
  state change intentionally waits for feedback, keep that wait short and make
  cancellation safe.
- Test gesture and continuous motion on real, lower-performance supported
  hardware rather than judging only from a simulator, emulator, or unusually
  powerful development device.

Target the platform's native refresh rate. Evaluate smoothness frame by frame;
an average frame-rate number can hide a visible hitch at the beginning,
interruption, or landing.

## Component motion contract

Every animated component specification must define:

- the purpose of each animation and how often it is expected to occur;
- the trigger, start state, destination state, path, and transform origin;
- every animated property and how coordinated properties relate over time;
- exact durations and easing curves for enter, exit, state change, return, and
  other distinct phases;
- spring parameters and velocity handoff when physics drives the motion;
- gesture directions, intent threshold, resistance, commit threshold, velocity
  rule, and cancellation behavior when direct manipulation is supported;
- how rapid repetition, reversal, interruption, and concurrent state changes
  behave;
- how content, shape, clipping, shadow, scrim, haptics, and sound stay
  synchronized;
- for shared elements, the matching identity, endpoint eligibility, animated
  properties, transition layering, missing-endpoint fallback, and return
  behavior;
- the reduced-motion alternative;
- lifecycle behavior when the component is hidden, obscured, or the software
  is inactive; and
- the performance and visual states used to validate the result.

Do not copy values from another component because its animation looks similar.
Start from this foundation, then choose values that fit the new component's
geometry, frequency, consequence, and platform behavior.

## Validation

An animation fits Mateo when:

- its purpose is understandable without watching it repeatedly;
- feedback begins at the moment of interaction;
- source, direction, origin, and destination form one spatial story;
- the person can interrupt or reverse interactive motion without a jump;
- gesture-driven motion follows the person's input and hands off velocity
  cleanly;
- entering, exiting, and state-changing properties remain synchronized;
- every shared element starts and lands on its exact endpoint without a
  duplicate, reflow flicker, stretched image, clipping error, or layering
  conflict;
- shared movement remains easy to track, reverses to the correct source, and
  falls back safely when either endpoint is unavailable;
- frequent use does not make the interface feel slower;
- loops have no visible seam and stop when no longer useful;
- reduced motion preserves the same action, meaning, and final state;
- text, icons, clipping, shape, and shadow remain visually attached;
- the first frame, interruptions, reversals, and final settle are free of
  dropped frames; and
- the motion feels expressive enough to be Mateo without competing with the
  person's task.

Review the animation at normal speed, in slow motion, and frame by frame. Test
rapid repeated input, reversal during motion, cancellation, leaving and
returning to the software, reduced motion, large text, and the least capable
supported device. Static screenshots can validate endpoints, but only
interactive review can validate feel.
