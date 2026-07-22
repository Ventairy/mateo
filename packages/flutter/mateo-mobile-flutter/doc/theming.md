# Theming

## Recommended integration

Use `MateoApp` or `MateoApp.router`. Both install the Mateo theme, mobile system
UI styling, and the overlay infrastructure required by Mateo components.

`MateoApp` keeps the primary surface and its foreground together in a required
package-level `color` record:

```dart
MateoApp(
  title: 'My App',
  color: (
    primary: const Color(0xFFFF4A4B),
    onPrimary: const Color(0xFFFFFFFF),
  ),
  home: const HomeScreen(),
)
```

`primary` must be opaque. Mateo preserves it at primary step 9 and regenerates
the complete primary and neutral scales using the design-system OKLCH recipe.
`onPrimary` is used for text and icons on primary buttons, indicators, and
Material primary surfaces. Consumers must verify the pair's contrast.

Use an active, vivid primary seed; pale, pastel, near-white, muted, and very
dark seeds need manual review.

Palette generation does not validate semantic contrast. Recheck every important
foreground/background pair after overriding the seed.

## Reading Mateo values

Access the active theme through `context.mateo`:

```dart
final mateo = context.mateo;
final textColor = mateo.colorScheme.text.primary;
final primarySeed = mateo.palette.primary[9];
```

Use component color schemes when implementing a Mateo component. Use shared
text, inverse, overlay, control, skeleton, scrollbar, and map roles where their
contracts apply. Raw palette steps are primitives and should not replace a
defined component token.

## Manual MaterialApp integration

When an application must keep its own `MaterialApp`, install
`MateoTheme.light()` and add `MateoToastMessenger` above the navigator-owned
content:

```dart
MaterialApp(
  theme: MateoTheme.light(
    primaryColor: const Color(0xFF8E51FF),
    onPrimary: const Color(0xFFFFFFFF),
  ),
  home: const HomeScreen(),
  builder: (context, child) => MateoToastMessenger(
    child: child ?? const SizedBox.shrink(),
  ),
)
```

This is an advanced integration. `MateoApp` remains the complete package-owned
application shell.
