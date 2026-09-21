import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'mateo_page_transition_direction.dart';

part '_mateo_page_transition_motion.dart';
part 'transitions/push/_mateo_push_page_transition_view.dart';
part 'transitions/push/_render_mateo_push_page_transition.dart';
part 'transitions/push/mateo_page_transition_push.dart';
part 'transitions/slide/_mateo_slide_closing_curve.dart';
part 'transitions/slide/_mateo_slide_opening_curve.dart';
part 'transitions/slide/_mateo_slide_page_transition_view.dart';
part 'transitions/slide/mateo_page_transition_slide.dart';
part 'transitions/wash/_mateo_wash_page_transition_painter.dart';
part 'transitions/wash/_mateo_wash_page_transition_view.dart';
part 'transitions/wash/mateo_page_transition_wash.dart';

/// A motion style connecting two Mateo pages.
///
/// Use with MateoPage or MateoPageTransitionsBuilder.
@immutable
sealed class MateoPageTransition {
  const MateoPageTransition._({required this.direction, required this.duration, required this.reverseDuration});

  /// Creates a feathered reveal of the destination from a screen edge.
  const factory MateoPageTransition.wash({
    MateoPageTransitionDirection direction,
    Duration duration,
    Duration? reverseDuration,
  }) = MateoPageTransitionWash;

  /// Creates attached page movement that blends the departing page into the destination edge.
  const factory MateoPageTransition.push({
    MateoPageTransitionDirection direction,
    Duration duration,
    Duration? reverseDuration,
  }) = MateoPageTransitionPush;

  /// Creates page movement from a screen edge while the previous page stays still.
  const factory MateoPageTransition.slide({
    MateoPageTransitionDirection direction,
    Duration duration,
    Duration reverseDuration,
  }) = MateoPageTransitionSlide;

  /// The physical direction of forward travel.
  final MateoPageTransitionDirection direction;

  /// The time used to open the destination.
  final Duration duration;

  /// The time used to return to the previous page.
  final Duration reverseDuration;

  /// Builds the arriving page using the route animation.
  @internal
  Widget buildIncoming({
    required Animation<double> animation,
    required bool allowSnapshotting,
    required Widget child,
  });

  /// Builds the departing page using the next route’s animation.
  @internal
  Widget buildOutgoing({
    required Animation<double> animation,
    required bool allowSnapshotting,
    required Widget child,
  });

  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType &&
      other is MateoPageTransition &&
      other.direction == direction &&
      other.duration == duration &&
      other.reverseDuration == reverseDuration;

  @override
  int get hashCode => Object.hash(runtimeType, direction, duration, reverseDuration);
}
