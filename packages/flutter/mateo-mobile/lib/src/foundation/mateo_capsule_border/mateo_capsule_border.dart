import 'dart:math' as math;

import 'package:flutter/foundation.dart' show internal;
import 'package:flutter/painting.dart';

import '../mateo_border_contour.dart';

part '_mateo_capsule_path.dart';

/// A Mateo capsule border that becomes a circle in square bounds.
///
/// Use this shape for compact controls whose width follows their content.
/// Its outline adapts automatically to the current bounds.
///
/// ```dart
/// ShapeDecoration(
///   color: MateoTheme.of(context).colorScheme.background,
///   shape: const MateoCapsuleBorder(),
/// )
/// ```
///
/// See the [capsule foundation](https://github.com/Ventairy/mateo/blob/main/design-system/foundation/capsule.md)
/// for its portable geometry and visual behavior.
final class MateoCapsuleBorder extends ShapeBorder {
  /// Creates a capsule without a painted stroke or layout inset.
  const MateoCapsuleBorder();

  /// The zero inset of this stroke-free shape.
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  /// The same shape, whose size is determined entirely by its bounds.
  @override
  MateoCapsuleBorder scale(double t) => this;

  /// The interpolation from another Mateo capsule, or the inherited fallback.
  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) => a is MateoCapsuleBorder ? this : super.lerpFrom(a, t);

  /// The interpolation to another Mateo capsule, or the inherited fallback.
  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) => b is MateoCapsuleBorder ? this : super.lerpTo(b, t);

  /// The interior outline, identical to [getOuterPath] because there is no stroke.
  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => getOuterPath(rect, textDirection: textDirection);

  /// The capsule outline within [rect], independent of [textDirection].
  ///
  /// Empty or non-finite bounds produce an empty path.
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _mateoCapsulePath(rect);
  }

  /// Paints no stroke; decorations paint the interior using [getOuterPath].
  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  bool operator ==(Object other) => other is MateoCapsuleBorder;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'MateoCapsuleBorder()';
}

// Direct native geometry for the convex foundation; not exported to consumers.
@internal
List<MateoBorderCubic> mateoCapsuleCubics(Size size) {
  final cubics = <MateoBorderCubic>[];
  _mateoCapsulePath(Offset.zero & size, onCubic: cubics.add);
  return cubics;
}

Path _mateoCapsulePath(Rect rect, {void Function(MateoBorderCubic)? onCubic}) {
  if (rect.isEmpty || !rect.isFinite) return Path();
  final aspectRatio = rect.longestSide / rect.shortestSide;
  if (!aspectRatio.isFinite) return Path();
  if (aspectRatio == 1 && onCubic == null) return Path()..addOval(rect);
  final progress = (aspectRatio - 1).clamp(0.0, 1.0);
  final weight = progress * progress * progress * (progress * (6 * progress - 15) + 10);
  final remaining = 1 - progress;
  final shoulderWeight = weight + 0.12 * remaining * remaining * remaining * (1 - weight);
  final referenceRatio = 1 + (aspectRatio - 1) * shoulderWeight;
  return _MateoCapsulePath(referenceRatio).create(rect, aspectRatio - referenceRatio, onCubic: onCubic);
}
