import 'package:flutter/foundation.dart';

/// The maximum resisted movement in each physical direction.
///
/// Values are finite, non-negative logical pixels. Zero disables a direction.
@immutable
class MateoDragResistanceConfig {
  /// Creates a configuration with [value] in every direction.
  const MateoDragResistanceConfig.all(double value) : this.only(top: value, right: value, bottom: value, left: value);

  /// Creates a configuration with matching limits on each axis.
  ///
  /// [vertical] controls top and bottom; [horizontal] controls left and right.
  const MateoDragResistanceConfig.symmetric({double vertical = 0, double horizontal = 0})
    : this.only(top: vertical, right: horizontal, bottom: vertical, left: horizontal);

  /// Creates a configuration for individual physical directions.
  const MateoDragResistanceConfig.only({this.top = 0, this.right = 0, this.bottom = 0, this.left = 0})
    : assert(top >= 0 && top < double.infinity, 'top must be finite and non-negative.'),
      assert(right >= 0 && right < double.infinity, 'right must be finite and non-negative.'),
      assert(bottom >= 0 && bottom < double.infinity, 'bottom must be finite and non-negative.'),
      assert(left >= 0 && left < double.infinity, 'left must be finite and non-negative.');

  /// A configuration with no resisted movement.
  static const zero = MateoDragResistanceConfig.all(0);

  /// The maximum upward movement in logical pixels.
  final double top;

  /// The maximum rightward movement in logical pixels.
  final double right;

  /// The maximum downward movement in logical pixels.
  final double bottom;

  /// The maximum leftward movement in logical pixels.
  final double left;

  @override
  bool operator ==(Object other) =>
      other is MateoDragResistanceConfig &&
      top == other.top &&
      right == other.right &&
      bottom == other.bottom &&
      left == other.left;

  @override
  int get hashCode => Object.hash(top, right, bottom, left);
}
