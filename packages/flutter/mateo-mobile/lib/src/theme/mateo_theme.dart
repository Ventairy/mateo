import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'mateo_theme_data.dart';
import 'mateo_typography.dart';

part '_mateo_theme_scope.dart';

/// An inherited Mateo appearance and shared text defaults for its descendants.
///
/// Nested themes replace the nearest appearance. Changes apply immediately,
/// without animation. This scope does not require Material or paint a surface.
/// It preserves inherited text sizes and layout settings, while applying
/// Inter, Mateo letter spacing, and the primary text color. Descendants can
/// override those text defaults normally.
///
/// ```dart
/// MateoTheme(
///   data: MateoThemeData.light(
///     accentColor: const Color(0xFF4A5CFF),
///     onAccent: const Color(0xFFFFFFFF),
///   ),
///   child: Builder(
///     builder: (context) => ColoredBox(
///       color: MateoTheme.of(context).colorScheme.background,
///       child: const SizedBox.shrink(),
///     ),
///   ),
/// )
/// ```
class MateoTheme extends StatelessWidget {
  /// Creates a theme applying [data] to [child].
  const MateoTheme({required this.data, required this.child, super.key});

  /// The immutable appearance provided to descendants.
  final MateoThemeData data;

  /// The subtree receiving the appearance and text defaults.
  final Widget child;

  /// The nearest theme for [context], subscribing to its changes.
  ///
  /// Throws [FlutterError] when there is no ancestor [MateoTheme].
  static MateoThemeData of(BuildContext context) {
    final data = maybeOf(context);
    if (data != null) return data;
    throw FlutterError.fromParts([
      ErrorSummary('MateoTheme.of() called without a MateoTheme ancestor.'),
      ErrorDescription('Wrap this subtree in MateoTheme and use a descendant BuildContext.'),
      context.describeElement('The context used was'),
    ]);
  }

  /// The nearest theme for [context], or null when no theme is present.
  ///
  /// Subscribes to changes, including a subsequently introduced scope.
  static MateoThemeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_MateoThemeScope>()?.data;

  /// Builds the inherited scope and shared text defaults.
  @override
  Widget build(BuildContext context) => _MateoThemeScope(
    data: data,
    child: DefaultTextStyle.merge(
      style: TextStyle(
        fontFamily: MateoTypography.fontFamily,
        letterSpacing: MateoTypography.letterSpacing,
        color: data.colorScheme.text.primary,
      ),
      child: child,
    ),
  );
}
