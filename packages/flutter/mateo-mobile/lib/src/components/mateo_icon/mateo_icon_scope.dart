import 'package:flutter/widgets.dart';

part '_resolved_mateo_icon_scope.dart';

/// Inherited size and monochrome color defaults for Mateo icons.
///
/// Nested scopes inherit omitted properties independently. Explicit properties
/// on an icon always win. Components supply their resolved state colors here;
/// changes apply immediately without adding animation or affecting other icons.
///
/// ```dart
/// MateoIconScope(
///   size: 24,
///   color: foregroundColor,
///   child: const MateoIcon(.cross),
/// )
/// ```
class MateoIconScope extends StatelessWidget {
  /// Creates defaults for [child] using optional [size], [sizeWithBackground], and [color].
  const MateoIconScope({required this.child, super.key, this.size, this.sizeWithBackground, this.color})
    : assert(size == null || (size >= 0 && size < double.infinity), 'size must be finite and nonnegative.'),
      assert(
        sizeWithBackground == null || (sizeWithBackground >= 0 && sizeWithBackground < double.infinity),
        'sizeWithBackground must be finite and nonnegative.',
      );

  /// The default square icon size, or null to inherit.
  final double? size;

  /// The default square size when the icon has a background, or null to inherit.
  ///
  /// Falls back to [size] when no scope supplies a background size.
  final double? sizeWithBackground;

  /// The default monochrome icon color, or null to inherit.
  final Color? color;

  /// The merged defaults above [context], subscribing to their changes.
  ///
  /// Returns null properties when no ancestor supplies them.
  static ({double? size, double? sizeWithBackground, Color? color}) of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ResolvedMateoIconScope>();
    return (size: scope?.size, sizeWithBackground: scope?.sizeWithBackground, color: scope?.color);
  }

  /// The subtree receiving these defaults.
  final Widget child;

  /// Builds the merged defaults for descendants.
  @override
  Widget build(BuildContext context) {
    final parent = of(context);
    return _ResolvedMateoIconScope(
      size: size ?? parent.size,
      sizeWithBackground: sizeWithBackground ?? parent.sizeWithBackground,
      color: color ?? parent.color,
      child: child,
    );
  }
}
