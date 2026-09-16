# Mateo Mobile for Flutter

`mateo_mobile` is the current Flutter implementation of Mateo Mobile for
Android and iOS. It provides Mateo components, theming, and navigation.

## Installation

This package is under development and is not published from this checkout.
Use a local path dependency:

```yaml
dependencies:
  mateo_mobile:
    path: /path/to/mateo/packages/flutter/mateo-mobile
```

```dart
import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  runApp(
    MateoApp(
      theme: MateoThemeData.light(
        accentColor: const Color(0xFF4A5CFF),
        onAccent: const Color(0xFFFFFFFF),
      ),
      home: const Center(child: Text('Hello, Mateo')),
    ),
  );
}
```
