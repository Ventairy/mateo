import 'package:flutter/animation.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

final _targets = <(Object, Duration, Curve), MateoTransformTarget>{};

MateoTransformTarget surfaceTransformTarget(
  Object scenario, {
  Duration duration = const Duration(milliseconds: 230),
  Curve curve = Curves.easeOutCubic,
}) => _targets.putIfAbsent(
  (scenario, duration, curve),
  () => MateoTransformTarget(
    duration: .custom(duration: duration),
    curve: curve,
  ),
);
