# Mateo Mobile for Flutter

[![CI](https://github.com/Ventairy/mateo/actions/workflows/mateo-mobile-flutter.yml/badge.svg)](https://github.com/Ventairy/mateo/actions/workflows/mateo-mobile-flutter.yml)
[![pub package](https://img.shields.io/pub/v/mateo_mobile.svg)](https://pub.dev/packages/mateo_mobile)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/Ventairy/mateo/blob/main/packages/flutter/mateo-mobile-flutter/LICENSE)

`mateo_mobile` is the Flutter implementation of Mateo Mobile: a simple,
expressive, warm design system for touch-first Android and iOS applications.
It includes Mateo foundations, application theming, tactile controls, loading
and feedback patterns, gesture-driven navigation, maps, and purposeful motion.

[Example](https://github.com/Ventairy/mateo/tree/main/packages/flutter/mateo-mobile-flutter/example) ·
[Components](https://github.com/Ventairy/mateo/blob/main/packages/flutter/mateo-mobile-flutter/doc/components.md) ·
[Theming](https://github.com/Ventairy/mateo/blob/main/packages/flutter/mateo-mobile-flutter/doc/theming.md) ·
[Performance and accessibility](https://github.com/Ventairy/mateo/blob/main/packages/flutter/mateo-mobile-flutter/doc/performance.md)

> [!IMPORTANT]
> Android and iOS are the supported platforms. Web and desktop are outside the
> package contract, even when an individual widget happens to compile there.
> Mateo currently supports a light appearance only; dark mode is not supported.

## Installation

The package targets Flutter 3.44.0. Add the latest compatible release from
pub.dev:

```yaml
dependencies:
  mateo_mobile: ^0.1.0
```

Then run `flutter pub get`.

## Quick start

`MateoApp` installs Mateo's theme, system UI styling, and toast infrastructure:

```dart
import 'package:flutter/material.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MateoApp(
      title: 'My App',
      color: (
        primary: const Color(0xFFFF4A4B),
        onPrimary: const Color(0xFFFFFFFF),
      ),
      home: Scaffold(
        body: Center(
          child: MateoButton(
            label: 'Continue',
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
```

Use `MateoApp.router` for declarative routing. If the application must keep its
own `MaterialApp`, follow the [manual integration guide](https://github.com/Ventairy/mateo/blob/main/packages/flutter/mateo-mobile-flutter/doc/theming.md).

## Brand color

`MateoApp` keeps the primary seed and the foreground placed on primary surfaces
together in a required package-level record:

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

Mateo preserves `primary` at primary step 9 and regenerates both the primary and
neutral scales. `onPrimary` becomes the foreground for primary buttons,
indicators, and Material primary surfaces. Verify the pair's contrast for the
content sizes used by the application.

The recipe is designed for active colors in roughly the same lightness range as
Mateo violet. Pale, pastel, near-white, muted, or very dark seeds require manual
visual and accessibility review.

Generation creates palette primitives; it does not guarantee accessible
foreground/background combinations. Verify important pairs after changing the
seed. Mateo component color schemes remain the source for component styling.

## Public surface

The package exports its supported API from
`package:mateo_mobile/mateo_mobile.dart`.

| Area                  | Included APIs                                                                  |
| --------------------- | ------------------------------------------------------------------------------ |
| Application and theme | `MateoApp`, `MateoTheme`, `MateoPalette`, `MateoColorScheme`, Inter typography |
| Actions               | Buttons, icon buttons, button bars, search bar button, tap feedback            |
| Feedback              | Bottom sheets, typed toasts, skeletons, loading indicators                     |
| Navigation and motion | Heroes, route settling, swipe-to-pop, appear and transition primitives         |
| Feeds and gestures    | Swipe deck, vertical feed, drag resistance, swipe hints                        |
| Visuals and maps      | Dot matrix, orbit, radar pulse, location-radius map, MapLibre style models     |

See the [component guide](https://github.com/Ventairy/mateo/blob/main/packages/flutter/mateo-mobile-flutter/doc/components.md)
and runnable [example](https://github.com/Ventairy/mateo/blob/main/packages/flutter/mateo-mobile-flutter/example/lib/main.dart)
for usage.

## Accessibility and performance

Mateo respects reduced motion, text scaling, safe areas, semantic labels, and
touch-target requirements. Consumers remain responsible for their content,
navigation, localization, device matrix, and accessibility validation. See
[performance and accessibility](https://github.com/Ventairy/mateo/blob/main/packages/flutter/mateo-mobile-flutter/doc/performance.md).

## License

`mateo_mobile` is available under the [MIT License](https://github.com/Ventairy/mateo/blob/main/packages/flutter/mateo-mobile-flutter/LICENSE). Inter is
distributed under the SIL Open Font License 1.1. See
[third-party notices](https://github.com/Ventairy/mateo/blob/main/packages/flutter/mateo-mobile-flutter/THIRD_PARTY_NOTICES.md).
