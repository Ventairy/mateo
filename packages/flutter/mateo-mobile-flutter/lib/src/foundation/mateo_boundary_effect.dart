import 'package:flutter/foundation.dart';

/// A semantic effect that protects content passing a visual boundary.
///
/// Components resolve the effect from their own local geometry and color. The
/// effect never intercepts input and contributes no semantics.
@immutable
final class MateoBoundaryEffect {
  /// Creates a vertical fade at the selected boundaries.
  ///
  /// [top] and [bottom] independently select the physical boundaries that
  /// receive the effect.
  const MateoBoundaryEffect.fade({this.top = true, this.bottom = true});

  /// Whether the top boundary receives the effect.
  final bool top;

  /// Whether the bottom boundary receives the effect.
  final bool bottom;

  @override
  bool operator ==(Object other) => other is MateoBoundaryEffect && other.top == top && other.bottom == bottom;

  @override
  int get hashCode => Object.hash(top, bottom);
}
