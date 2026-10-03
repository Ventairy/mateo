# Internal Mateo Bases

This folder owns shared implementation bases for widgets, routes, and any
other classes used by multiple implementations. Every base is internal:
annotate it with `@internal`, keep it out of package exports, and never present
it as a consumer API.

- Use the `BaseMateo` prefix, such as `BaseMateoSurface` or
  `BaseMateoPageRoute`, consistently for every kind of base.
- Concrete implementations compose or extend bases and own their public
  contracts. Do not expose internal base coordination through public APIs.
- Bases own behavior shared by the implementations that compose or extend
  them. Keep dependencies narrow: depend on configuration contracts rather
  than concrete consuming implementations for shared behavior. Widget bases
  may compose a narrowly scoped internal component scope when that behavior
  is shared.
- When behavior varies by public implementation, keep it with that consumer or
  accept only the narrow values and notifications the base needs.
- Keep each base in a same-named folder. Tightly coupled helpers are private
  classes in private part files; keep a StatefulWidget and its State together.
- Keep validation in the owner of each contract. Shared layout validation
  belongs in the base; component ownership checks belong in the component.
- Preserve platform-native behavior and the applicable Mateo foundations.
