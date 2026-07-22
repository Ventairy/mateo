# Border radius — Mateo Mobile

Mateo Mobile inherits its shapes, geometry, nesting, usage, and motion rules
from the shared [border-radius foundation](../foundation/border-radius.md).
This document defines only how mobile interfaces interact with the border
radius foundation.

## Near the display boundary

Some mobile surfaces adapt their fixed corners to follow a rounded display.
When a component calls for this behavior:

- prefer system-provided display-corner information and treat each reported
  corner independently;
- account for the component's space from the physical display edge;
- use the component's platform fallback when display-corner information is
  unavailable; and
- recalculate the shape after orientation, window size, safe-area, or keyboard
  changes.

Each component owns its exact radius, spacing, limits, and fallback
calculation. See [Bottom sheet](components/bottom-sheet.md) for the specification
of one display-aware mobile surface.
