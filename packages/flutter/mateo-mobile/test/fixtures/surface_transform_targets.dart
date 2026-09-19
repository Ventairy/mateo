import 'package:flutter/animation.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

final _targets = <(Object, Duration, Curve), MateoSurfaceTransformTarget>{};

MateoSurfaceTransformTarget surfaceTransformTarget(
  Object scenario, {
  Duration duration = const Duration(milliseconds: 230),
  Curve curve = Curves.easeOutCubic,
}) => _targets.putIfAbsent(
  (scenario, duration, curve),
  () => MateoSurfaceTransformTarget(duration: duration, curve: curve),
);
