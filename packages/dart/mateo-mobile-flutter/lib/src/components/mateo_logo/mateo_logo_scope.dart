import 'package:flutter/widgets.dart';

part '_resolved_mateo_logo_scope.dart';

/// An inherited size default for Mateo logos.
///
/// Nested scopes inherit an omitted size. Explicit sizes on a logo take
/// precedence. This scope is independent of icon sizing and colors.
///
/// ```dart
/// const MateoLogoScope(size: 24, child: MateoLogo(.gmail))
/// ```
class MateoLogoScope extends StatelessWidget {
  /// Creates a size default for [child] using optional [size].
  const new({required this.child, super.key, this.size})
    : assert(size == null || (size >= 0 && size < double.infinity), 'size must be finite and nonnegative.');

  /// The default square logo size, or null to inherit.
  ///
  /// Must be finite and nonnegative. Zero hides logos without an explicit size.
  final double? size;

  /// The subtree receiving the size default.
  final Widget child;

  /// The resolved default above [context], subscribing to size changes.
  ///
  /// Returns a null size when no ancestor supplies one.
  static ({double? size}) of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ResolvedMateoLogoScope>();
    return (size: scope?.size);
  }

  /// Builds the inherited size default for descendants.
  @override
  Widget build(BuildContext context) => _ResolvedMateoLogoScope(
    size: size ?? of(context).size,
    child: child,
  );
}
