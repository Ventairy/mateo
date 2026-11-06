import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart' show MaybeSafeAreaTransform;

import 'mateo_page_transition_direction.dart';

part '_mateo_page_transition_motion.dart';
part 'transitions/fade/_mateo_fade_closing_curve.dart';
part 'transitions/fade/_mateo_fade_opening_curve.dart';
part 'transitions/fade/_mateo_fade_page_transition_view.dart';
part 'transitions/fade/mateo_page_transition_fade.dart';
part 'transitions/push/_mateo_push_page_snapshot_painter.dart';
part 'transitions/push/_mateo_push_page_transition_renderer.dart';
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
  const new _({required this.duration, required this.reverseDuration});

  /// Creates a full-page fade over a stationary previous page.
  const factory fade({
    Duration duration,
    Duration reverseDuration,
  }) = MateoPageTransitionFade;

  /// Creates a feathered reveal of the destination from a screen edge.
  const factory wash({
    MateoPageTransitionDirection direction,
    Duration duration,
    Duration? reverseDuration,
  }) = MateoPageTransitionWash;

  /// Creates attached page movement that blends the departing page into the destination edge.
  const factory push({
    MateoPageTransitionDirection direction,
    Duration duration,
    Duration? reverseDuration,
  }) = MateoPageTransitionPush;

  /// Creates page movement from a screen edge while the previous page stays still.
  const factory slide({
    MateoPageTransitionDirection direction,
    Duration duration,
    Duration reverseDuration,
  }) = MateoPageTransitionSlide;

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
      other.runtimeType == runtimeType && other is MateoPageTransition && other._configuration == _configuration;

  Object get _configuration => switch (this) {
    MateoPageTransitionFade() => (duration, reverseDuration),
    MateoPageTransitionPush(:final direction) ||
    MateoPageTransitionSlide(:final direction) ||
    MateoPageTransitionWash(:final direction) => (direction, duration, reverseDuration),
  };

  @override
  int get hashCode => Object.hash(runtimeType, _configuration);
}
