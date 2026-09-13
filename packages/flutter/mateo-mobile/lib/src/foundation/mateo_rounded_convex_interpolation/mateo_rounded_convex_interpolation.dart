import 'dart:typed_data';

import 'package:flutter/painting.dart';

import 'mateo_rounded_convex_evaluator.dart';
import 'mateo_rounded_convex_geometry.dart';
import 'mateo_rounded_convex_preparation.dart';

part '_mateo_rounded_convex_border.dart';
part '_mateo_rounded_convex_border_cache.dart';

/// A prepared transition for rounded convex border outlines and their sizes.
///
/// Create this when the endpoints change, then reuse [lerp] with the progress
/// from an animation. Paint or clip with the returned border at its paired size.
/// Corners and sides change together at an even outline pace. Capsule ends
/// retain their character as straight sides grow into a panel. Width and height
/// follow the supplied progress, with gentle resistance beyond the endpoints.
///
/// ```dart
/// final interpolation = MateoRoundedConvexInterpolation(
///   begin: (shape: const MateoCapsuleBorder(), size: const Size(144, 48)),
///   end: (shape: const MateoRoundedRectangleBorder(radius: 24), size: const Size(240, 280)),
/// );
/// final frame = interpolation.lerp(animation.value);
/// ```
///
/// Custom borders must provide one closed convex outer contour occupying their
/// supplied bounds. Strokes, insets, holes, and concave outlines are not part of
/// this transition. Invalid or unrepresentable geometry throws [ArgumentError].
/// Sharp convex outlines are accepted, but preserving sharp corners is not an
/// intended use. Each supplied border is already the desired endpoint outline.
/// Borders are immutable values: provide a new, unequal border when its outline
/// changes. Equivalent endpoints can share their prepared geometry.
///
/// See the [rounded-convex-interpolation foundation](https://github.com/Ventairy/mateo/blob/main/design-system/foundation/rounded-convex-interpolation.md).
final class MateoRoundedConvexInterpolation {
  /// Creates a transition and prepares the outline movement between [begin] and [end].
  ///
  /// Directional borders resolve using [textDirection]. Both dimensions of
  /// each endpoint's size must be positive and finite.
  MateoRoundedConvexInterpolation({
    required this.begin,
    required this.end,
    this.textDirection,
  }) {
    _unchanged = begin == end;
    _begin = _prepare(begin);
    _end = _unchanged ? _begin : _prepare(end);
    _evaluator.prepare(_begin, _end);
  }

  /// The beginning shape and its physical bounds, in logical pixels.
  final ({ShapeBorder shape, Size size}) begin;

  /// The ending shape and its physical bounds, in logical pixels.
  final ({ShapeBorder shape, Size size}) end;

  /// The direction used to resolve directional endpoint borders.
  final TextDirection? textDirection;

  late final MateoRoundedConvexDescription _begin;
  late final MateoRoundedConvexDescription _end;
  late final bool _unchanged;
  ({double progress, ({Size size, ShapeBorder border}) frame})? _last;
  final _evaluator = MateoRoundedConvexEvaluator(
    intervals: mateoRoundedConvexIntervals,
    locations: mateoRoundedConvexLocations,
  );

  MateoRoundedConvexDescription _prepare(
    ({ShapeBorder shape, Size size}) endpoint,
  ) => switch (endpoint.shape) {
    final _MateoRoundedConvexBorder border => border.prepare(endpoint.size),
    _ => prepareMateoRoundedConvexBorder(
      endpoint.shape,
      endpoint.size,
      textDirection,
    ),
  };

  /// The coordinated size and border at [progress], including overshoot.
  ///
  /// Zero represents [begin], and one represents [end]. Finite progress outside
  /// that range continues the transition while keeping dimensions positive.
  /// Unrepresentable results throw [ArgumentError]. Previously returned borders
  /// remain unchanged by subsequent calls.
  ({Size size, ShapeBorder border}) lerp(double progress) {
    if (!progress.isFinite) {
      throw ArgumentError.value(
        progress,
        'progress',
        'Progress must be finite.',
      );
    }
    final last = _last;
    if (last != null && (_unchanged || last.progress == progress)) return last.frame;
    final width = mateoRoundedConvexDimension(
      begin.size.width,
      end.size.width,
      progress,
    );
    final height = mateoRoundedConvexDimension(
      begin.size.height,
      end.size.height,
      progress,
    );
    if (!width.isFinite ||
        !height.isFinite ||
        width <= 0 ||
        height <= 0 ||
        width > 3.4e38 ||
        height > 3.4e38 ||
        width < 1e-37 ||
        height < 1e-37) {
      throw ArgumentError.value(
        progress,
        'progress',
        'Progress produces unrepresentable dimensions.',
      );
    }
    final size = Size(width, height);
    final evaluated = _evaluator.evaluatePathFrame(
      _begin,
      _end,
      progress,
      Offset.zero & size,
    );
    final frame = (
      size: size,
      border: _MateoRoundedConvexBorder.lazy(
        evaluated.path,
        capture: evaluated.capture,
        transform: evaluated.transform,
        pathTolerance: evaluated.pathTolerance,
        size: size,
      ),
    );
    _last = (progress: progress, frame: frame);
    return frame;
  }
}
