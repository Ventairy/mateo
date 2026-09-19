import 'package:flutter/foundation.dart';

import 'mateo_surface_animation/mateo_surface_animation.dart';

enum _SheetToViewTag { surface }

@internal
const MateoSurfaceAnimationTransform kSheetToViewTransformAnimation = .new(
  id: _SheetToViewTag.surface,
  duration: .new(milliseconds: 320),
  shape: .rounded(radius: 42),
  contentEffects: [.crossfade()],
);
