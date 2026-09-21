import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

import '../../foundation/mateo_rounded_shape_border/mateo_rounded_shape_border.dart';
import '../../foundation/mateo_transform_animation_content_effect/mateo_transform_animation_content_effect.dart';
import '../../foundation/mateo_transform_target/mateo_transform_target.dart';

part '_base_mateo_transform_candidate.dart';
part '_base_mateo_transform_targets.dart';
part 'transform_animation/_mateo_surface_transform_animation_flight_engine.dart';
part 'transform_animation/_mateo_transform_animation_flight_content.dart';
part 'transform_animation/_mateo_transform_animation_flight_delegate.dart';
part 'transform_animation/_mateo_transform_animation_flight_frame.dart';
part 'transform_animation/_mateo_transform_animation_flight_layer.dart';
part 'transform_animation/_mateo_transform_animation_flight_scaled_border.dart';
part 'transform_animation/_mateo_view_transform_animation_flight_engine.dart';
part 'transform_animation/effects/_mateo_transform_animation_content_crossfade.dart';
part 'transform_animation/effects/_mateo_transform_animation_content_effect.dart';
part 'transform_animation/effects/_mateo_transform_animation_content_effects.dart';
part 'transform_animation/effects/_mateo_transform_animation_content_scale.dart';
part 'transform_animation/effects/_mateo_transform_animation_content_switch.dart';

@internal
class BaseMateoTransform extends StatelessWidget {
  const BaseMateoTransform({
    required this.child,
    required this.content,
    required this.color,
    required this.candidates,
    this.canMatch,
    super.key,
  }) : assert(candidates.length > 0, 'candidates must not be empty.');

  final Widget child;
  final Widget content;
  final Color color;
  final List<BaseMateoTransformCandidate> candidates;
  final bool Function(MorphTarget target, MorphMatchContext match)? canMatch;

  @override
  Widget build(BuildContext context) {
    return Morph(
      targets: candidates.map((candidate) => candidate.target).toList(),
      canMatch: canMatch,
      flightConfig: .custom(
        _MateoTransformAnimationFlightDelegate(
          color: color,
          content: content,
          candidates: candidates,
        ),
      ),
      child: child,
    );
  }
}
