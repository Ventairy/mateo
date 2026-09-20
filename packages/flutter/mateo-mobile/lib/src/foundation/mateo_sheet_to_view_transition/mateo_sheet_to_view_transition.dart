import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';

import '../mateo_surface_animation/mateo_surface_animation.dart';
import '../mateo_surface_animation/mateo_surface_transform_target.dart';

part '_sheet_to_view_curve.dart';

@internal
final MateoSurfaceAnimationTransform kSheetToViewTransformAnimation = .new(
  target: MateoSurfaceTransformTarget(
    duration: const .new(milliseconds: 280),
    curve: const _SheetToViewCurve(),
  ),
  shape: const .rounded(radius: 42),
  contentEffects: const [.crossfade()],
);
