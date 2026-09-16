# Mateo Component Implementation

These instructions apply to all Flutter widgets under this directory and
extend the package-level `AGENTS.md` rules.

## Member Scope

- Do not declare widget-specific constants, variables, getters, or helper
  functions at library scope.
- For a `StatefulWidget`, keep immutable configuration and static visual tokens
  on the widget class. Put mutable runtime fields and lifecycle helpers on its
  corresponding `State` class. A concrete presentation follows this rule even
  when its `State` is the primary consumer of the presentation's tokens.
- For a `StatelessWidget`, place its implementation constants and helpers on
  the widget class.
- Keep top-level declarations only when Dart requires a separate type or when
  the declaration is intentionally shared by multiple widgets in the library.

## Presentation Ownership

- Every component with different rendering modes must define a
  `<ComponentName>Presentation` class with a named factory for each mode.
  This rule applies to all component types. Named `const` constructors may
  serve as factories. Each factory exposes only the configuration relevant to
  its rendering mode. Use this pattern instead of adding rendering-mode flags
  or unrelated optional parameters to the widget API. The named presentation
  constructors and factories are the stable public API. A generic
  `<ComponentName>Variant` is appropriate when all modes share the same
  presentation field model, as with `MateoTextFieldVariant`; the presentation
  constructors still initialize those fields. When modes need distinct field
  models, keep them as distinct named presentations instead of flattening
  them into a generic variant enum.
- The main component widget owns presentation-independent state and
  coordination that every presentation needs, such as callback dispatch,
  loading state, selected data, controller ownership, or a shared navigation
  protocol. It may also own a reusable engine mechanism that must coordinate
  across core boundaries, such as connecting a menu trigger to its route. In
  that case, the core exposes a narrow capability such as a transition tag and
  presentations opt in by consuming it. Shared parameters that the engine must
  read, such as a duration or curve, remain narrow presentation overrides. The
  core must not branch on concrete presentation types or absorb the
  presentation's complete UI.
- The public `<ComponentName>Presentation` base is a routing and contract
  boundary. Keep it limited to named factories and the narrow properties or
  methods the component core must access. Do not put visual constants, styles,
  layout values, builders, shared rendering, or a generic presentation
  implementation on the base.
- Each concrete presentation owns its complete visible implementation: widget
  tree, visual tokens, theme-role selection, layout, local animation,
  interaction response, semantics, painters, render objects, and
  presentation-specific lifecycle. A core-owned engine remains limited to its
  cross-boundary mechanism and the contract the presentation configures.
  The presentation may expose overridable properties or methods only when the
  component core has a real need to communicate with it.
- Concrete presentations must not share visual widgets or implementation
  helpers with one another. Duplicate presentation-specific UI and visual
  values intentionally so each presentation can diverge or be detached without
  changing another mode. Shared Mateo foundations and semantic theme contracts
  remain in their canonical owners; do not duplicate those system definitions.
- Use a private scope when the component core needs to make state or capabilities
  available to a presentation subtree. Prefer a narrow owner interface and an
  `InheritedWidget` around the presentation over a shared visual base widget or
  a large parameter relay.
- A simple presentation may live in one file. Put a complex presentation in
  its own directory under `presentations/`, with its `StatefulWidget` and
  corresponding `State` together and each additional private helper type in a
  focused part file. All helpers in that directory belong only to that concrete
  presentation.

## Boundary Effect Ownership

- Do not create or restore a global edge-fade component. Each component or
  concrete presentation that needs a boundary fade owns a private renderer,
  geometry, and scroll response suited to that use case.
- Share the semantic `MateoBoundaryEffect` contract and foundation guidance,
  but do not share visible fade widgets, painters, render objects, or visual
  constants across components.
