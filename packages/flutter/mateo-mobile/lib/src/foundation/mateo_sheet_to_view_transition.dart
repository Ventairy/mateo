import 'package:flutter/foundation.dart';

import 'mateo_surface_animation/mateo_surface_animation.dart';
import 'mateo_surface_animation/mateo_surface_transform_target.dart';

@internal
final MateoSurfaceAnimationTransform kSheetToViewTransformAnimation = .new(
  target: MateoSurfaceTransformTarget(duration: const .new(milliseconds: 320)),
  shape: const .rounded(radius: 42),
  contentEffects: const [.crossfade()],
);
