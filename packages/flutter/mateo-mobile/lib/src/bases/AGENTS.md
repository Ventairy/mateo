# Internal Mateo Bases

This folder owns shared implementation widgets composed by public Mateo
components. Every base is internal: annotate it with `@internal`, keep it out
of package exports, and never present it as a consumer API.

- Use the `BaseMateo` prefix here, such as `BaseMateoSurface`. This is a local
  exception to the Flutter parent rule requiring a `Base` suffix.
- Public components compose bases and own their documented public constructors
  and contracts. Do not expose base coordination inputs through public APIs.
- Bases own behavior shared by every public implementation that composes them.
  They may compose a narrowly scoped internal component scope when that
  behavior is universal. Keep the dependency narrow and do not import the
  public consuming wrappers that compose the base.
- When behavior varies by public implementation, keep it with that consumer or
  accept only the narrow values and notifications the base needs.
- Keep each base in a same-named folder. Tightly coupled helpers are private
  classes in private part files; keep a StatefulWidget and its State together.
- Keep validation in the owner of each contract. Shared layout validation
  belongs in the base; component ownership checks belong in the component.
- Preserve platform-native behavior and the applicable Mateo foundations.
