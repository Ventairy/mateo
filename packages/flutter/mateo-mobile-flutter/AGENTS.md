# AGENTS.md — Mateo

## Purpose

Mateo is a simple, expressive, warm design system for software that feels
obvious, kind, tactile, and human.

Mateo Mobile adapts the system for touch-first Android and iOS applications.
Its Flutter implementation is the `mateo_mobile` package at
`packages/flutter/mateo-mobile-flutter`.

`mateo_mobile` must remain portable for consumers with no access to any
Ventairy product, service, configuration, or private asset. Web and desktop are
not supported product targets.

## Standalone environment

- Use Flutter 3.44.0 exclusively through FVM.
- The committed lockfile is the deterministic development and CI resolution.
- Use this package's Makefile. This repository does not use Melos.
- Keep `publish_to: none` until the release checklist is complete and publishing
  is explicitly authorized.
- Clone `oh_my_flutter` beside this repository and use the ignored package
  override files for local development.
- Run `make check` before pull requests and `make pana` for publication changes.
- Do not change copied files under `.agents` merely to satisfy package linting.

## Dart Documentation

### Naming

In Dart doc comments, always refer to the design system as `Mateo`. `Mateo` is a
standalone name: do not expand it or present it as an acronym. Use `mateo_mobile`
only when referring specifically to the Dart package, its import path, or its
release identity. Do not introduce another design-system name for the mobile
package: this package is the Flutter implementation of Mateo Mobile.

### Every Public Member Must Have Dartdoc

Every public class, constructor, method, property, enum, enum value, typedef,
and top-level function **must** have a `///` doc comment. There are no
exceptions for "obvious" members — `dart doc` surfaces all public declarations
and a missing doc comment is a visible gap. Private (`_`-prefixed) members must
**not** have dartdoc.

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
/// Creates a text hero that animates [TextStyle], content, and wrapping
/// behavior between source and destination.
///
/// The [TextStyle] is interpolated via [TextStyle.lerp] across the full
/// flight. Text content and layout constraints ([maxLines], [overflow])
/// switch from the source configuration to the destination configuration
/// at the exact midpoint (50 %) of the flight animation.
factory MateoHero.text({ … })
```

### Class Documentation Structure

A well-documented class follows this order:

1. First sentence (what it **is**)
2. Blank `///` line
3. Detailed prose — 2‑4 paragraphs explaining behavior, invariants, and edge cases
4. Structured subsections with `##` headings (e.g. `## How it works`, `## Choosing a variant`, `## Performance`)
5. Code samples — prefer fenced ` ```dart ` blocks
6. `See also:` bulleted list

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

## Public Package Portability

Treat `mateo_mobile` as a package that can be released publicly on pub.dev and
used by any Flutter mobile app. Widgets must be portable, defensive, and
configurable across Android and iOS environments instead of assuming a
specific product's services, infrastructure, assets, data shapes, or provider
capabilities.

### Portability rules

- Do not hardcode product-only URLs, signed tokens, backend assumptions, or
  environment-specific operational details in reusable widgets.
- Public widget APIs should describe real external capabilities when those
  capabilities can vary by consumer. For example, map widgets should accept
  tile source capability bounds such as `tileMinZoom` and `tileMaxZoom` instead
  of assuming every provider supports the same zoom range.
- Keep convenience defaults only when they are
  broadly safe and easy for external consumers to override.
- Before adding a widget assumption, ask whether it can break if a consuming app
  has a different tile server, locale, asset setup, theme, mobile screen size,
  input data, Android or iOS version, network policy, or accessibility
  configuration.
- Do not expand web or desktop behavior unless the package scope is changed
  explicitly. Incidental compilation on those platforms is not a compatibility
  guarantee.
- Prefer small explicit configuration over hidden fixed behavior when the value
  represents an external system contract rather than visual taste.

## Golden Testing

Every new widget in `mateo_mobile` must have a corresponding golden test file at
`test/widgets/<widget_name>_golden_test.dart`.

### Golden test rules

- Cover all visual states (resting, active, error, loading, disabled, etc.)
  using `GoldenTestScenario` and `GoldenTestGroup`.
- Use `goldenTest` from `alchemist`, not raw `matchesGoldenFile`.
- Configure `AlchemistConfig` in `test/flutter_test_config.dart` with
  `MateoTheme.light(primaryColor: ...)` so theme tokens resolve in all golden
  scenarios.
- Commit CI goldens stored at `test/widgets/goldens/ci/`.
- Gitignore platform goldens stored at `test/widgets/goldens/macos/`,
  `test/widgets/goldens/linux/`, and `test/widgets/goldens/windows/`.
- Regenerate approved goldens from the repository root with
  `make goldens`.
- Golden tests complement unit tests; they do not replace non-visual tests.
- Resolve test colors from the same `MateoThemeData` applied by the test. Use
  its color scheme when the target consumes semantic colors, and use its
  palette only when the target consumes palette primitives. Fixed colors are
  allowed only when the exact color value is the contract under test, such as
  palette anchors, custom seeds, alpha validation, or color interpolation.
- Use the shared test theme for default widget and golden scenarios. A test
  with a custom theme must derive its expected colors from that exact theme.
  Golden changes remain the visual signal for intentional color-scheme edits.

## Descriptive Naming

All tests must use the `when, should` pattern for descriptions.

- **Format:** `when <condition/action>, it should <expected result>`
- **Example:** `when MateoSearchBarButton is tapped, it should invoke the onTap callback`
- Avoid vague descriptions like `renders correctly` or `test login`.

## Structure

```text
mateo-mobile-flutter/
├── lib/
│   ├── mateo_mobile.dart       # Single public entrypoint for consumers
│   └── src/
│       ├── gen/                # Generated asset code — do not edit
│       ├── icons/              # MateoIcon — SVG icon namespace
│       ├── theme/              # Design tokens and theme data
│       └── widgets/            # Reusable mobile UI components
├── example/
├── test/
└── pubspec.yaml
```

## Conventions

- All public widgets are exported from
  `packages/flutter/mateo-mobile-flutter/lib/mateo_mobile.dart` with explicit
  `show`.
- Widgets live in the package's `lib/src/widgets/` directory. Simple widgets
  may use one file. Larger widgets may use a same-named folder with one public
  entrypoint and focused `part` files for public value types, controllers,
  actions, and other support classes, following the `mateo_swipe_deck`
  structure.

- Access bundled SVG icons via `MateoIcon` (e.g. `MateoIcon.cross(width: 16, height: 16, color: Colors.red)`),
  exported from the barrel. `MateoIcon` is an `abstract final class` with one `static Widget` method per icon,
  delegating to dotdart's generated `$Icons` namespace. Add an `.svg` to `assets/icons/` and run
  `make generate` to generate the dotdart accessor, then add a static method to `MateoIcon`.
  Do not import `src/gen/icons.g.dart` directly from widget code; use `MateoIcon`.
- Private declarations (`_`-prefixed classes, methods, fields, and part files for private types) must NOT have dartdoc. Private code should be self-explanatory through naming and structure alone. dartdoc is reserved for the public API surface that consumers outside the package can see.

## Releases

Follow [RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md) for all release rules and
verification steps.
