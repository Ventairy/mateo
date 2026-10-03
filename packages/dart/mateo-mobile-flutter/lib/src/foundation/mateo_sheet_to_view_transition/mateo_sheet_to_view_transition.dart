import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';

import '../mateo_transform_duration/mateo_transform_duration.dart';
import '../mateo_transform_target/mateo_transform_target.dart';
import '../mateo_view_animation/mateo_view_animation.dart';

part '_sheet_to_view_curve.dart';
part '_view_to_sheet_curve.dart';

// One second normalizes the spring to curve progress; the route owns timing.
final _sheetViewSpring = SpringSimulation(
  SpringDescription.withDurationAndBounce(
    duration: const Duration(seconds: 1),
  ),
  0,
  1,
  0,
);

@internal
final MateoViewAnimationTransform kSheetToViewTransformAnimation = .new(
  target: MateoTransformTarget(
    duration: .custom(duration: const Duration(milliseconds: 280)),
    reverseDuration: .custom(duration: const Duration(milliseconds: 250)),
    curve: const _SheetToViewCurve(),
    reverseCurve: const _ViewToSheetCurve(),
  ),
  shape: const .rounded(radius: 42),
  contentEffects: const [.crossfade()],
);

@internal
({Duration forward, Duration reverse}) get sheetToViewTransformDurations => (
  forward: _routeDuration(kSheetToViewTransformAnimation.duration),
  reverse: _routeDuration(kSheetToViewTransformAnimation.reverseDuration),
);

Duration _routeDuration(MateoTransformDuration duration) =>
    duration.value ?? (throw StateError('The automatic sheet-to-view transform requires custom route timing.'));
