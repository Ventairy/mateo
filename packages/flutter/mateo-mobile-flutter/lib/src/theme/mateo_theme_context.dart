import 'package:flutter/material.dart';

import 'mateo_theme_data.dart';

/// Convenience access to [MateoThemeData] from any [BuildContext].
///
/// ```dart
/// Container(
///   color: context.mateo.colorScheme.background,
/// )
/// ```
extension MateoThemeContext on BuildContext {
  /// The [MateoThemeData] registered in the widget tree above this context.
  MateoThemeData get mateo => Theme.of(this).extension<MateoThemeData>()!;
}
