# Internal Mateo Bases

This folder owns shared implementation widgets composed by public Mateo
components. Every base is internal: annotate it with `@internal`, keep it out
of package exports, and never present it as a consumer API.

- Use the `BaseMateo` prefix here, such as `BaseMateoSurface`. This is a local
  exception to the Flutter parent rule requiring a `Base` suffix.
- Public components compose bases and own their documented public constructors
  and contracts. Do not expose base coordination inputs through public APIs.
- Bases must not import consuming components or their inherited scopes. Accept
  the narrow values and notifications needed by their implementation instead.
- Keep each base in a same-named folder. Tightly coupled helpers are private
  classes in private part files; keep a StatefulWidget and its State together.
- Keep validation in the owner of each contract. Shared layout validation
  belongs in the base; component ownership checks belong in the component.
- Preserve platform-native behavior and the applicable Mateo foundations.
