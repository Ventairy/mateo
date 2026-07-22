# System controls — Mateo Mobile Design System

System controls are the interface drawn by the operating system at the edges
of the phone. They include status information at the top and navigation
controls at the bottom, such as Android navigation buttons, the Android gesture
handle, and the iOS home indicator.

Mateo gives these regions no separate background. They are fully transparent
so the app remains visually continuous from one physical edge of the display
to the other. The [viewport edge fade](../foundation/viewport-edges.md) paints
behind the controls and gives them a clean, readable surface without creating
a hard system bar.

## Required layering

The following order describes visual depth, not vertical screen position.
Number `1` is the farthest layer in the background; number `4` is the nearest
layer to the person, painted above all the others.

Paint the layers from back to front in this order:

1. the app background and scrollable content extending to the device edge;
2. the bottom viewport edge fade, anchored to the physical bottom edge of the
   display;
3. non-scrollable app content and fixed app-owned controls; and
4. the operating system's navigation controls.

Use the same back-to-front order at the top: app background and scrollable
content, a top edge fade anchored to the physical top edge, non-scrollable app
content and fixed controls, then the operating system's status controls.

The fade does not begin after the system region. It begins at the device edge
and extends inward through the entire system-control area. The system controls
therefore sit above the opaque part of the fade rather than above content or a
separate bar.

```text
Vertical position from the inside of the app toward the bottom edge:

inside of the app
        ↓ toward the physical bottom edge
transparent end of edge fade
gradual edge fade
opaque edge fade + system controls
physical device edge
```

Follow the foundation document for the fade's color, depth, stops, clipping,
and transition behavior. Do not define a second system-control gradient.

## Background and color

The status-bar and navigation-bar backgrounds are always transparent. Do not
add a solid fill, translucent scrim, divider, border, or platform-default
contrast layer behind them.

The edge fade uses the semantic background of the surface currently reaching
the viewport edge. The fade and the screen must resolve their color from the
same appearance so their opaque areas join without a seam. A screen with a
different edge surface updates the fade to that surface; it does not tint the
system bar itself.

System-control symbols use the platform's light or dark symbol appearance,
chosen for clear contrast against the opaque end of the edge fade. Treat symbol
appearance and background transparency as separate decisions:

- changing symbol appearance must not introduce a system-bar background;
- changing the screen surface must update the fade and symbol appearance
  together; and
- use one symbol appearance throughout a system region unless the platform
  itself owns a temporary overlay that requires another treatment.

The mobile color scheme owns the transparent system-bar background and the
preferred symbol appearance. See the
[mobile color scheme](color-scheme.md#system-ui). A screen may select a more
appropriate symbol appearance when its edge surface changes, but it must still
meet the same contrast and transparency rules.

## Safe areas and content

Draw the screen background and edge fade through the top and bottom safe areas
to the physical display edges. Do not use a safe-area inset as the fade's
starting point, because that would leave a separate block behind the system
controls and reveal a hard boundary where the app content begins.

Scrollable content must also render through the safe areas to the physical
display edges. Do not inset or clip the scrollable viewport at a safe-area
boundary. List items, page content, and other scrolling elements must be able
to travel behind the safe area and beneath the system controls. The stationary
edge fade gradually hides that moving content before it visually competes with
the controls.

Give the scrollable content enough internal space at its beginning and end for
its first and last items to be scrolled into a fully visible position. This
space belongs inside the scrolling content. It must not shorten or clip the
scrollable viewport.

Non-scrollable content follows the opposite rule. Static text, fixed actions,
app bars, floating buttons, persistent navigation, and other content that does
not move with the scroll must remain inside the safe content region and paint
above the edge fade. Because it cannot move away from the gradient, placing it
under the fade would leave it permanently obscured.

The edge fade is visual only and must not change the safe-area measurement,
consume layout space, intercept gestures, or interfere with operating-system
navigation. Scrollable content may pass through the protected region, but
non-scrollable controls must not occupy the system gesture or navigation area.

## App-owned controls near an edge

Fixed app controls remain above the edge fade and inside the device's safe
content region. This includes app bars, floating buttons, floating search
controls, bottom actions, persistent navigation, and any other control that
rests near the top or bottom of the screen.

Apply the safe-area distance to the control, not to the fade:

- At the top, place the control at or below the inner boundary of the top safe
  area. The top fade still begins at the physical top edge behind it.
- At the bottom, place the control at or above the inner boundary of the bottom
  safe area. The bottom fade still begins at the physical bottom edge behind
  it.

Safe-area spacing is the minimum separation from system controls. A component
may require additional spacing for its own layout, but it must add that space
inward from the safe-area boundary. It must never move the edge fade inward.

Do not place non-scrollable content beneath the fade merely because pointer
input can pass through it. Fixed content must remain completely visible,
visually above the gradient, and reachable without competing with a system
gesture. Only scrolling content travels beneath the fade while entering or
leaving the viewport.

## Android

Android supports both gesture navigation and button navigation. Use the same
edge-to-edge construction for both.

For the navigation region:

- make the navigation-bar background fully transparent;
- remove the navigation-bar divider;
- disable an automatically enforced contrast scrim when the supported Android
  version provides that control;
- place the bottom edge fade behind the complete navigation region, starting
  at the physical bottom edge; and
- choose navigation-button or gesture-handle appearance for contrast against
  the fade's opaque surface.

With three-button navigation, the Back, Home, and Overview buttons remain
operating-system controls painted above the fade. Do not draw an app-owned bar
behind them and do not start the fade at the top of their reserved region.

If an Android version or device policy adds system-owned protection that the
app cannot disable, preserve legibility and platform behavior. Do not imitate
that protection with another app-owned layer on versions where full
transparency is available.

## iOS

Allow the app surface and edge fades to extend underneath the status area and
home-indicator area. The status information and home indicator remain
system-owned and paint above the fades.

Choose the status-symbol appearance for contrast with the top fade. Do not add
an app-owned rectangle behind the status information or home indicator. Keep
interactive app content outside the protected safe areas even though the
visual background continues through them.

## Screen changes and overlays

When navigation changes the surface reaching an edge, update the surface, edge
fade, and system-symbol appearance as one visual state. The fade must never
flash to a default color or briefly expose an opaque platform bar between
screens.

Temporary full-screen surfaces may require a different symbol appearance. They
still keep the system background transparent and provide their own matching
edge treatment. When the surface closes, restore the underlying screen's fade
and symbol appearance with the same transition.

## Accessibility and platform behavior

System controls must retain their native size, position, gestures, semantics,
and accessibility behavior. Mateo personalizes only the surface visible behind
them and the supported symbol appearance; it does not redraw or replace the
controls.

Honor operating-system accessibility settings that change system-control
visibility or contrast. Verify that the controls remain distinguishable from
the edge fade without relying on the content scrolling beneath them.

## Validation

A Mateo screen handles system controls correctly when:

- the status and navigation regions have no app-owned background, divider, or
  scrim;
- the app surface reaches both physical display edges;
- each edge fade starts at the physical device edge, not after the safe area or
  system-control region;
- Android navigation buttons and gesture controls appear above the bottom fade;
- iOS status information and the home indicator appear above their fades;
- system symbols remain clearly visible against the opaque edge surface;
- scrollable viewports are not inset or clipped at safe-area boundaries;
- scrolling content can travel through the safe areas beneath the fades and
  system controls;
- the first and last scrolling items can reach a fully visible position;
- non-scrollable content, including app bars and floating buttons, remains
  above the fades and inside the safe content region;
- the fades do not intercept system gestures or app interaction;
- changing screens produces no color seam, opaque system bar, or flash; and
- gesture navigation, Android three-button navigation, safe-area changes, and
  supported accessibility settings have been checked on their actual mobile
  platforms.
