# Mateo Mobile for Flutter

[![CI](https://github.com/Ventairy/mateo/actions/workflows/mateo-mobile-flutter-check.yml/badge.svg)](https://github.com/Ventairy/mateo/actions/workflows/mateo-mobile-flutter-check.yml)
[![pub package](https://img.shields.io/pub/v/mateo_mobile.svg)](https://pub.dev/packages/mateo_mobile)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/Ventairy/mateo/blob/main/packages/flutter/mateo-mobile-flutter/LICENSE)

`mateo_mobile` is the Flutter implementation of [Mateo](https://github.com/Ventairy/mateo) for mobile software, a simple,
expressive, warm design system.

Use it when you want a mobile interface that feels like it was made with care,
careful with motion, generous with feedback, and ready for real product
surfaces.

## What You Get

- A complete Mateo app shell with theme, overlays, typography, and system UI.
- Branded buttons, icon buttons, text buttons, search actions, and tap feedback.
- Mobile feedback patterns including bottom sheets, typed toasts, skeletons,
  loading text, and animated indicators.
- Gesture-first building blocks for swipe navigation, drag resistance, hero
  motion, vertical snap feeds, and edge fades.
- Mobile foundations for color, typography, maps, reduced motion, safe areas,
  touch targets, and semantic labels.

Mateo Mobile currently supports Android and iOS. Web and desktop are separate
platform lanes, not targets of this Flutter package.

## Install

```shell
flutter pub add mateo_mobile
```

The package targets the current Mateo Flutter lane. See
[`pubspec.yaml`](https://github.com/Ventairy/mateo/blob/main/packages/flutter/mateo-mobile-flutter/pubspec.yaml)
for the exact SDK constraint.

## Start

`MateoApp` is the recommended integration. It installs the Mateo theme, mobile
system UI styling, and overlay infrastructure used by Mateo components.

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
      color: const (
        primary: Color(0xFFFF4A4B),
        onPrimary: Color(0xFFFFFFFF),
      ),
      home: Scaffold(
        body: Center(
          child: MateoButton(
            label: 'Continue',
            variant: MateoButtonVariant.primary,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
```

Use `MateoApp.router` for declarative routing. If your app must keep its own
`MaterialApp`, use the
[manual integration guide](https://github.com/Ventairy/mateo/blob/main/packages/flutter/mateo-mobile-flutter/doc/theming.md#manual-materialapp-integration).

## Use Components

Every public API is exported from one entry point:

```dart
import 'package:mateo_mobile/mateo_mobile.dart';
```

```dart
MateoButton(
  label: 'Save changes',
  variant: MateoButtonVariant.primary,
  onPressed: saveChanges,
)

MateoToast.show(
  context,
  message: 'Saved',
  type: MateoToastType.success,
)
```

For exact component behavior, variants, states, and ownership rules, use the
component guide as the source of truth.

## Explore Mateo Mobile

| Need                            | Go to                                                                                                             |
| ------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| Run the package                 | [Example app](https://github.com/Ventairy/mateo/tree/main/packages/flutter/mateo-mobile-flutter/example)          |
| Pick a component                | [Component guide](https://github.com/Ventairy/mateo/tree/main/design-system/mobile/components)                    |
| Integrate theme and brand color | [Theming guide](https://github.com/Ventairy/mateo/blob/main/packages/flutter/mateo-mobile-flutter/doc/theming.md) |
| Read exact Dart contracts       | [API reference](https://pub.dev/documentation/mateo_mobile/latest/)                                               |
| Review releases                 | [Changelog](https://github.com/Ventairy/mateo/blob/main/packages/flutter/mateo-mobile-flutter/CHANGELOG.md)       |

## Platform Notes

Mateo respects reduced motion, text scaling, safe areas, platform navigation
expectations, semantic labels, and touch-target requirements. Your app remains
responsible for its own content, localization, device matrix, route structure
and product-specific accessibility validation.
