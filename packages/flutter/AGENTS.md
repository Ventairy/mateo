# Mateo Flutter Packages

This directory contains Mateo's public Flutter packages. These packages turn
Mateo's foundations and platform design guidance into reusable Dart APIs,
widgets, themes, and tokens for Flutter applications.

Each package lives in its own subdirectory with its implementation,
documentation, examples, and tests.

The repository-level and parent `packages/AGENTS.md` instructions still apply.
These rules apply to all Flutter packages in this directory; package-specific
guidance belongs in each package's own `AGENTS.md`.

## Toolchain And Package Environment

- This directory is the Flutter Pub workspace and Melos root. Register packages
  explicitly in its `pubspec.yaml`; currently only `mateo-mobile` participates.
- Use the Flutter version in this directory's `.fvmrc` exclusively through FVM.
  Do not add separate SDK pins to workspace members.
- The root `analysis_options.yaml` owns lint rules, formatter settings, and
  shared exclusions. Members inherit it automatically. Keep the lint dependency
  at the workspace root rather than repeating it in package manifests.
- Commit the workspace-root `pubspec.lock`; do not commit member lockfiles.
- Package SDK constraints remain in each manifest for Dart and publication.
  `melos bootstrap` synchronizes them with the root environment configuration.
- Run `fvm dart run melos get` from this directory to fetch workspace dependencies.

## Coding Rules

### Implement Only Current Needs

- Add code only when it serves a concrete use in the current task or existing
  implementation. Do not add parameters, branches, abstractions, helpers, or
  extension points because they might be useful later.
- Introduce new capabilities when an actual requirement needs them. A test
  written solely to exercise a speculative capability does not justify it.
- Keep the implementation limited to today's supported behavior; do not build
  infrastructure for hypothetical future variants or consumers.

### Subscribe Only To Needed MediaQuery Properties

- Never use `MediaQuery.maybeOf(context)` directly. It subscribes to every
  media property, rebuilding the caller for changes it may not use.
- Read individual properties with accessors such as `MediaQuery.paddingOf`,
  `MediaQuery.viewInsetsOf`, and `MediaQuery.sizeOf`, or their nullable
  `maybe` variants when no ancestor is supported.
- Do not substitute `MediaQuery.of(context)` for a property-specific read;
  it has the same broad subscription. When forwarding the complete media data
  with a scoped override, isolate that full-data subscription in the smallest
  builder that owns the override and keep its child stable. Preserve all
  other media settings and their updates.

### Use Clear, Boring Names

- Name functions and variables for their responsibility or meaning, not only
  the feature or caller currently using them. Use feature-specific names only
  when the behavior or value is inherently specific to that feature. For
  example, use `disablePrimaryTransition()` rather than
  `suppressPrimaryTransitionAboveSheet()`: disabling primary motion is a route
  capability; deciding to do so above a sheet belongs to the caller. Do not
  add speculative generalization to the implementation merely to match a name.
- Use highly descriptive names whose purpose is understandable from the name
  alone. Name both the subject and the property when a shorter name would make
  the reader inspect nearby code to learn what it controls. For example, use
  `loadingIndicatorSize` instead of `indicatorSize` for a loading indicator's
  dimensions.
- Name fields, variables, parameters, and methods so their purpose is clear
  from the name alone. Prefer familiar, concrete words over clever names,
  abbreviations, or generic labels that require tracing the implementation.
- Include the subject when it distinguishes what a value belongs to. For
  example, use `headerSafeAreaHandle` instead of `handle`, and
  `contentGeometry` instead of `geometry` when coordinating header and content.
- Keep names proportional to their scope: add meaningful context, not redundant
  type names or implementation details.

### Prefer Early Returns

- Prefer guard clauses and early returns over `if`/`else` branches when they
  reduce nesting and make the remaining flow easier to read.
- When a branch completes the method's work, return from that branch and place
  the alternative afterward instead of wrapping it in `else`.
- Preserve required cleanup and shared work. Keep branching when early returns
  would duplicate logic or make the flow harder to follow.

### Keep Stateful Implementation In State

- For a `StatefulWidget`, place implementation getters, methods, variables,
  constants, and lifecycle resources directly in its `State` class by default.
  This includes derived configuration that only its state uses, even when it
  depends solely on immutable widget properties. Read those through `widget`.
- Keep constructor parameters, immutable input properties, and `createState`
  on the widget. Keep other members there only when they are needed as part of
  the widget's contract or must be available independently of its state.
- For widgets without a `State` class, keep implementation members on the
  widget. Do not introduce state solely to relocate a getter or helper.

### Keep Builders Focused On UI

- Keep `build` methods and builder callbacks lean. Include only context reads,
  local values, and decisions strictly necessary to compose the current UI.
- Put configuration tables, size mappings, and reusable calculations in named
  getters or methods on their owner instead of declaring them inside builders.
  Presentation-specific configuration belongs to its presentation; genuinely
  shared enum values remain on the enum.
- Keep inherited dependencies such as theme and scope reads in the appropriate
  build context. Do not cache them or create extra widgets merely to shorten a
  builder. Keep local values when they avoid repeated work or clarify the UI.

### Keep Enum Configuration In The Enum

- Define the meaning and fixed configuration of each enum value directly on
  the enum, using fields, constants, getters, and methods as appropriate.
- Use enhanced enum constructors and final fields for per-value configuration.
  Do not scatter that configuration across consumer switches, separate constant
  classes, lookup maps, or helpers that merely describe the enum's values.
- For example, an animation-style enum owns its target scale, opacity,
  durations, and curves. Consumers read that definition from the selected value.
- Keep per-widget mutable state and lifecycle resources, such as animation
  controllers and disposable listeners, with their widget or feedback owner.
  Enum values are shared; they must not store an individual consumer's state.

### Keep Implementation With Its Owner

- Place calculations and helpers beside the implementation whose behavior
  they produce. Depending on an enum does not make a calculation belong to
  that enum. Being pure or stateless does not make it shared configuration.
- Shared enums describe choices; consumers interpret those choices. Keep
  layout constraints with the layout owner, stack geometry with the stack,
  and paint coordinates, clipping, and transforms with the renderer.
- For example, a sheet source can define its direction, anchor, spacing, and
  timing. The stack computes resting and covered frames from those values;
  the renderer converts those frames into painting operations. Do not move
  those algorithms into the source enum merely to make them source-aware.
- Before extracting a helper, ask which implementation would need to change
  if its algorithm changed. Keep the helper with that owner. Extract shared
  behavior only when existing consumers actually need the same algorithm;
  do not use a shared enum as a container for consumer-specific utilities.

### Design Shared Contracts Around Intent

- Avoid designing a shared contract by forwarding whatever the current
  implementation accepts. The root mistake is treating a convenient
  implementation detail as the abstraction's responsibility: this couples
  every caller and alternative implementation to today's mechanism.
- Define inputs by the behavior the owner needs to express. Translate that
  intent into implementation-specific options inside the implementation that
  uses them. Do not require unrelated variants to understand another variant's
  engine, lifecycle, or configuration types.
- Before adding a shared parameter, ask whether its meaning would remain valid
  if the implementation changed. If it describes only how one implementation
  works, keep it with that implementation. Use framework or dependency types
  directly when they genuinely represent the shared contract.
- Apply this to all shared boundaries, including widgets, services, bases,
  configuration types, and helpers. This does not justify speculative adapters
  or extension points; express today's requirements with the smallest accurate
  contract.

### Keep Named-Constructor Configuration In Its Class

- When named constructors represent distinct configurations, initialize each
  configuration's fixed values directly in its constructor and expose them
  through final fields. Consumers read those fields from the selected instance.
- Do not repeat constructor-specific configuration in consuming widgets,
  bases, switches, lookup maps, or separate constant classes. For example,
  `MateoSurfaceAnimation.transform` owns its duration and curve.
- Fixed values do not need customization parameters. Keep per-instance
  execution state, controllers, and lifecycle resources with the consuming
  implementation rather than in a reusable configuration value.

### Give Variants Their Own Configuration Types

- When named constructor variants require different fields, use a sealed parent
  with concrete variant types and named redirecting factories.
- Put variant-specific required fields and fixed configuration on the concrete
  type, initializing fixed values in its constructor. Only genuinely shared
  configuration belongs on the parent.
- Avoid nullable catch-all fields, dummy values, and assertions that compensate
  for incompatible configurations. Consumers narrow the type before accessing
  variant-specific fields; use exhaustive pattern matching to interpret variants.
- Constructors that share the same field structure do not require separate types.
- When dispatching behavior across a sealed family or enum, handle every
  supported variant explicitly with exhaustive matching. Do not use a
  one-variant check followed by a catch-all no-op or default behavior: it makes
  new variants silently inherit behavior that was never chosen for them.
  Omit wildcard/default branches when the compiler can enforce completeness.
  A check for a capability relevant to only one variant may remain selective;
  dispatching the family's behavior must be exhaustive.

### Share Types Through Foundation

- Place types, enums, and configuration values shared by public components and
  internal bases in the package's `lib/src/foundation/`. Both layers must reuse
  that definition without importing a consuming component into a base.
- Pass shared configuration values unchanged to the base that owns their
  behavior. Do not split one configuration into multiple base properties,
  nullable values, or flags, or introduce a second definition for the base.
  For example, accept `MateoSurfaceAnimation animation` instead of extracting
  `transformId` and adding more parameters for future animation variants.
- Public components forward the configuration; the base interprets it and owns
  execution. Keep foundation types independent of rendering engines, and keep
  per-instance state and lifecycle resources with their implementation owner.

### Keep Validation In One Owner

- Keep each validation or assertion in the layer that owns the value's contract.
- Do not repeat validation in a caller or wrapper when the downstream API
  already validates that value. Delegate to the existing owner instead.
- Add validation locally only for a distinct contract that is not already
  enforced downstream. For example, `MateoSurface` delegates elevation range
  validation to the `MateoElevation` constructor.

### Always Use Dart Dot Shorthands Where Supported

- Always use Dart's dot shorthand syntax when the surrounding context allows
  Dart to infer the required type.
- Apply this consistently to enum values, static members, and constructors
  wherever the language supports it. Omit the redundant type name to keep code
  concise and easy to scan across implementations, examples, and tests.
- Use the fully qualified form only when dot shorthand cannot resolve the
  intended member or is unsupported by the package's Dart language version.

### Prefer Named Constructors And Arguments

- Use a named constructor by default when a type has multiple semantic
  configurations or when its unnamed form would obscure the intended role.
  Keep an unnamed constructor for an obvious value object whose positional
  argument explains itself, such as `PhoneNumber(phoneNumber)`.
- Use named arguments for presentation tokens, layout values, and other
  configuration bundles whose meaning cannot be matched reliably by position.
  Every value in a presentation initializer should be identifiable at the
  callsite, such as `verticalSpace: 24` and `borderRadius: ...`.

### Group Related Values With Records

- Use Dart records with named fields to group values or callbacks that form one
  logical input or result, instead of spreading them across separate parameters,
  fields, or variables.
- Name the group for its purpose and keep its members together at the callsite.
  For example, use `begin: (shape: shape, size: size)` instead of separate
  `begin` and `beginSize` arguments.
- Keep unrelated values separate. Use a class when the group needs its own
  behavior, validation, or lifecycle rather than only carrying related values.

### Preserve Property Documentation In Constructor Hovers

- Always use field-initializing parameters such as `this.elevation` for public
  constructor arguments that directly initialize documented properties. Use
  this pattern in every named constructor as well, and use `super.key` for
  inherited keys.
- Keep each property's description on its field. The analyzer can reuse that
  documentation when hovering the corresponding constructor argument.
- Do not replace these parameters with plain forwarding parameters and a
  private redirecting constructor merely to share initialization or assertions.
  Parameter-level Dartdoc macros do not fix the constructor-documentation
  fallback for this pattern in the current analyzer.
- Preserve the single validation owner. For widgets, shared build-time
  assertions can validate widget-specific layout contracts once without
  redirecting public constructors. Keep validated value-object contracts in
  their constructors; do not defer those checks merely for documentation.
- When constructor structure must change, verify analyzer hover output at a
  consumer callsite rather than assuming documentation is inherited.

### File Organization

- Export each package's public API from its documented library entrypoint with
  explicit `show` lists.
- Reusable widgets live under `lib/src/components/`.
- When a widget, ordinary class, or library has multiple supporting files owned
  by the same concept, group them in a same-named folder with one entrypoint
  and focused supporting files. This applies to foundation types and their
  variants too; do not scatter an owner's related files across the parent
  directory. For example, keep the three `MateoSurfaceAnimation` files under
  `foundation/mateo_surface_animation/`.
- Place shared implementation bases under `lib/src/bases/`, whether they are
  widgets, routes, or other classes. Use the `BaseMateo` prefix and a same-named
  folder, such as `bases/base_mateo_page_route/`. Keep bases internal and out of
  package exports. Extract a base only for behavior shared by actual multiple
  implementations; do not create speculative inheritance hierarchies.
- Keep one class per file. The only routine exception is a `StatefulWidget` and
  its corresponding `State`, which must remain together in the widget's file;
  do not extract the `State` into a separate `part` file.
- A supporting class that is tightly coupled to one public class and unlikely
  to be reused by other public declarations must be private and live in its own
  private `part` file of the owning library. Do not make an implementation
  detail public only to place it in a separate file.
- Keep a value inline when it is used in only one place. Extract it into a
  variable only when it is used in more than one place, then reuse that
  variable everywhere it is needed.

## Dart Documentation

### Avoid Duplicating Implementation Measurements

- Describe purpose, behavior, and usage in Dartdoc instead of listing concrete
  padding, spacing, sizes, radii, durations, or other implementation values.
- Keep those values in their owning code. Repeating them in prose creates a
  second source to maintain and makes documentation vulnerable to drift.
- Link to the owning property or type when useful. Include an exact value only
  when it is necessary to explain a consumer-facing contract, such as accepted
  units or a validation boundary.

### Keep Component Dartdoc Focused On Use

- Describe a widget or class by its purpose, when to use it, and a small
  usage example. Do not turn its Dartdoc into a list of everything it does.
- Adding a feature does not automatically require expanding the widget or
  class Dartdoc. Update that overview only when its purpose or essential usage
  changes. Document new configuration on the member that owns it, and include
  only what consumers need to use it correctly.
- Keep UI, visual, and interaction specifications in the component's canonical
  Mateo Markdown documentation. Link to that document instead of repeating its
  rules in class, constructor, or property comments.
- For example, `MateoSurface` Dartdoc should explain its role and show typical
  usage; its scroll physics belong in the Mateo component documentation.
- Keep member comments focused on the meaning of the API and any information
  needed to use it correctly. Do not turn them into visual specifications.
- Describe a class or property by the full role its abstraction represents,
  not by the behavior of its only current non-default variant. Always evaluate
  whether the API is intentionally specific or can support multiple purposes.
  Put variant-specific behavior and setup requirements on the constructor,
  enum value, or subtype that introduces them.
- When a documented design detail changes, update its owning component `.md`
  file without duplicating the documentation change in Dart comments. Update
  Dartdoc when the API's purpose or usage changes.

### Naming

In Dart doc comments, always refer to the design system as `Mateo`. `Mateo` is a
standalone name: do not expand it or present it as an acronym. Package-specific
instructions may define when to use a package's release or import name.

### Consumer-Facing APIs Must Have Dartdoc

Every consumer-facing class, constructor, method, property, enum, enum value,
typedef, and top-level function must have a `///` doc comment. There are no
exceptions for "obvious" consumer-facing members.

Internal components and their members must not have Dartdoc, even when their
Dart names are public for cross-library use. This includes `@internal` classes
and shared implementation bases. Private (`_`-prefixed) declarations must not
have Dartdoc either. Use ordinary `//` comments only when implementation
reasoning needs explanation.

### First Sentence Rule

The first sentence of every doc comment must be a complete, self-contained
statement ending with a period. It appears as the short summary in `dart doc`
lists and search results. Separate it from the rest of the comment with a blank
`///` line.

| Declaration type     | First sentence starts with                     |
| -------------------- | ---------------------------------------------- |
| Class                | Noun phrase describing what an instance **is** |
| Constructor          | "Creates a …"                                  |
| Method (side-effect) | Third-person verb describing what it **does**  |
| Method (returns)     | Noun phrase describing the **result**          |
| Non-bool property    | Noun phrase describing what it **is**          |
| Bool property        | "Whether …" followed by the condition          |
| Enum type            | Noun phrase describing the category            |
| Enum value           | Descriptive phrase                             |
| Typedef              | Noun phrase describing the signature           |

```
/// Creates a hero for text shared between pages.
///
/// Use this for a title that appears on both the source and destination page.
factory MateoHero.text({ … })
```

### Class Documentation Structure

A well-documented class follows this order:

1. First sentence (what it **is**)
2. Blank `///` line
3. Brief guidance on when to use it
4. A small usage example where helpful — prefer fenced ` ```dart ` blocks
5. Links to related APIs and the canonical Mateo component documentation

Keep this proportional to the API. Do not require detailed paragraphs or
subsections just to fill out the structure.

### Code Samples

Prefer fenced ` ```dart ` code blocks over indented ones. Every code sample
must be complete enough to copy‑paste and understand without surrounding
prose. Use `{@tool snippet}` blocks for inline examples and `{@tool dartpad}`
for interactive samples (though the latter requires a separate fixture file).

````dart
/// ```dart
/// MateoHero.background(
///   tag: 'card-1',
///   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
/// )
/// ```
````

### Parameter and Return Value Documentation

Document each constructor parameter, method parameter, and return value within
the enclosing doc comment using `[parameterName]` references — never
`@param` or `@return` tags (these are Java/JSDoc conventions, not Dart).

```
/// Wraps [child] with the behavior owned by this extension.
///
/// The [context] is the [BuildContext] at the point where the hero renders.
/// Use it to access the [MateoHeroPageRoute] via [MateoHeroPageRoute.maybeOf].
///
/// The returned widget replaces [child] in the hero's render tree.
Widget wrap({required BuildContext context, required Widget child});
```

### Keep Enum Variants as the Source of Truth

Do not list or name an enum's possible values in the documentation of a widget,
class, constructor, or property that consumes it. Describe the enum's role
through the typed property, and document value-specific behavior on the enum
and its values. The enum declaration must remain the only inventory of its
variants so adding or removing a value cannot leave duplicated documentation
stale.

### Cross-Reference Linking

Wrap type names, member names, and constructor names in square brackets `[]`
to create links in generated documentation:

| To link to             | Syntax                       |
| ---------------------- | ---------------------------- |
| Class                  | `[ClassName]`                |
| Named constructor      | `[ClassName.named]`          |
| Unnamed constructor    | `[ClassName.new]`            |
| Method                 | `[ClassName.method()]`       |
| Property / field       | `[ClassName.property]`       |
| Enum value             | `[EnumName.value]`           |
| Top-level function     | `[functionName()]`           |
| Member on `this` class | `[method()]` or `[property]` |

Use backticks `` ` ` `` for parameter names, code values, and expressions in
prose that do not need a link: `` `width` `` → `width`. Use `[width]` only
when `width` is a documented property you want to link to.

### Boolean Property Documentation

Every boolean property must start with "Whether" and describe the condition:

```
/// Whether an interactive pop gesture is currently in progress.
///
/// Returns `true` after a successful call to [startInteractivePop] and
/// `false` after [cancelInteractivePop] or [commitInteractivePop] completes.
bool get isInteractivePopActive => _isInteractivePopActive;
```

### "See Also" Sections

Place `See also:` at the end of class‑level and significant member‑level docs.
Each entry is a bullet (`*`) containing a `[Link]` followed by a comma and a
brief description of why the reader should care:

```
/// See also:
///  * [MateoHeroPageRoute], the route created by this page that manages hero
///    animations and the interactive-pop API.
///  * [MateoHero], the hero widget that flies between the source route and
///    this page.
///  * [MateoHeroDragToCloseExtension], the extension that wires drag gestures
///    to the route's interactive-pop API.
```

### Templates and Macros (`{@template}` / `{@macro}`)

Use `{@template}` and `{@macro}` when the same prose block is referenced
in **more than one** doc comment. Do **not** create templates for single-use
text.

- Define with: `/// {@template mateo_component_descriptive_name}` … `/// {@endtemplate}`
- Reference with: `/// {@macro mateo_component_descriptive_name}`
- Naming convention: `mateo_<component>_<descriptive_snake_case>`

Templates can be placed on any declaration (typedef, method, property) — they
do not need a dedicated location. Place each template on the declaration
where the concept is first introduced.

### Anti‑Patterns

| Avoid                               | Use instead                                                     |
| ----------------------------------- | --------------------------------------------------------------- |
| `//` for public docs                | `///` (only `//` is invisible to `dart doc`)                    |
| `/** … */` JavaDoc style            | `///` on every line                                             |
| `@param name Description`           | `[name]` inline in prose                                        |
| `@return Description`               | Describe the result in the method's first sentence              |
| No blank line after first sentence  | Always add blank `///` line before detailed prose               |
| `/// Constructor.`                  | `/// Creates a [ClassName] that …`                              |
| `/// Sets the tooltip.`             | Omit — it adds no information beyond the signature              |
| `/// The name.` / `/// The title.`  | Omit — the name is inferred unless there's a non‑obvious detail |
| Indented code blocks (4 spaces)     | Fenced ` ```dart ` blocks                                       |
| HTML tags in doc comments           | Markdown only                                                   |
| Abbreviations (i.e., e.g.)          | Spell it out: "for example", "that is"                          |
| Documenting both getter and setter  | Document only the getter — `dart doc` ignores setter docs       |
| `[hero]` when meaning `[MateoHero]` | Use the full type name — short links are ambiguous              |
| Redundant code in prose             | If already in a code block, don't repeat it verbatim            |

## Widget Testing

- Add regression tests only in the scope that owns the fix. Do not add tests
  to consuming components solely because they use the corrected behavior.
  For example, a fix in `MateoPress` belongs in that widget's
  tests, not in `MateoButton` tests. Add consumer regression coverage only when
  the fix also covers a consumer requirement.
- Every new reusable widget must have corresponding golden coverage under
  `test/widgets/`.
- Cover every visual state, including resting, active, error, loading, and
  disabled states, with `GoldenTestScenario` and `GoldenTestGroup`.
- Use `goldenTest` from `alchemist`, not raw `matchesGoldenFile`.
- Commit CI goldens under `test/widgets/goldens/ci/`. Gitignore platform goldens
  under `test/widgets/goldens/macos/`, `test/widgets/goldens/linux/`, and
  `test/widgets/goldens/windows/`.
- Golden tests complement behavioral and unit tests; they do not replace them.
- Derive expected colors from the exact theme applied by the test. Fixed colors
  are allowed only when the exact value is the contract under test.

## Tests As Behavior Documentation

- Write tests as executable documentation. Someone reading the descriptions,
  setup, actions, and assertions should understand the supported behavior
  without first reading the implementation.
- Choose meaningful scenarios that explain the contract: ordinary use,
  relevant alternatives, and boundary or failure cases. Assert observable
  outcomes rather than copying implementation calculations into expectations.
- Make each description state the concrete condition and expected behavior.
  Name parameterized cases by their meaning, not opaque numbers or labels such
  as `placement 3`. The test report should explain which behavior failed.
- Keep setup and assertions readable and focused. Use descriptive fixtures and
  helpers that reduce repetition without hiding the behavior being tested.
- Update descriptions and expectations together when behavior changes; do not
  leave a passing test describing an outdated rule.

## Test Naming

All tests must use the `when, should` pattern for descriptions.

- **Format:** `when <condition/action>, it should <expected result>`
- **Example:** `when MateoButton is tapped, it should invoke the onPressed callback`
- Avoid vague descriptions like `renders correctly` or `test login`.
