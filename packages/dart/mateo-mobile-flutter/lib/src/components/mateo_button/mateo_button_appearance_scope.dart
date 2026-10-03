import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'mateo_button_size.dart';
import 'variants/mateo_button_variant.dart';

/// Inherited appearance defaults for Mateo buttons.
///
/// Nested scopes inherit omitted properties independently. Explicit values on
/// a button presentation always win.
@internal
class MateoButtonAppearanceScope extends StatelessWidget {
  /// Creates appearance defaults for [child].
  const MateoButtonAppearanceScope({
    required this.child,
    super.key,
    this.variant,
    this.elevation,
    this.size,
  });

  /// The default semantic treatment, or null to inherit.
  final MateoButtonVariant? variant;

  /// The default surface lift, or null to inherit.
  final double? elevation;

  /// The default surface size, or null to inherit.
  final MateoButtonSize? size;

  /// The merged defaults above [context], subscribing to their changes.
  ///
  /// Properties remain null when no ancestor supplies them.
  static ({MateoButtonVariant? variant, double? elevation, MateoButtonSize? size}) of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ResolvedMateoButtonAppearanceScope>();
    return (variant: scope?.variant, elevation: scope?.elevation, size: scope?.size);
  }

  /// The subtree receiving these defaults.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final parent = of(context);
    return _ResolvedMateoButtonAppearanceScope(
      variant: variant ?? parent.variant,
      elevation: elevation ?? parent.elevation,
      size: size ?? parent.size,
      child: child,
    );
  }
}

class _ResolvedMateoButtonAppearanceScope extends InheritedWidget {
  const _ResolvedMateoButtonAppearanceScope({
    required this.variant,
    required this.elevation,
    required this.size,
    required super.child,
  });

  final MateoButtonVariant? variant;
  final double? elevation;
  final MateoButtonSize? size;

  @override
  bool updateShouldNotify(_ResolvedMateoButtonAppearanceScope oldWidget) =>
      variant != oldWidget.variant || elevation != oldWidget.elevation || size != oldWidget.size;
}
