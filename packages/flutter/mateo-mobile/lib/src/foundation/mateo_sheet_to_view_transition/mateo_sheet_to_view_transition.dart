import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';

import '../mateo_transform_target/mateo_transform_target.dart';
import '../mateo_view_animation/mateo_view_animation.dart';

part '_sheet_to_view_curve.dart';

@internal
final MateoViewAnimation kSheetToViewTransformAnimation = .transform(
  target: MateoTransformTarget(
    duration: const .new(milliseconds: 280),
    curve: const _SheetToViewCurve(),
  ),
  shape: const .rounded(radius: 42),
  contentEffects: const [.crossfade()],
);
