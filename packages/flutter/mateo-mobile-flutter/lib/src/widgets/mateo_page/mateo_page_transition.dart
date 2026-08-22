part of 'mateo_page.dart';

/// A transition configuration for [MateoPage].
///
/// Create a transition through one of the named factory constructors. The
/// class cannot be extended or implemented outside the Mateo package.
/// Explicit Mateo transitions disable the native iOS edge-swipe gesture so the
/// configured motion remains consistent. On Android, predictive back controls
/// the transition directly with linear gesture progress.
///
/// See also:
///  * [MateoPageTransition.wash], a soft circular reveal transition.
///  * [MateoPageTransition.push], an attached push that fades its source.
///  * [MateoPageTransitionDirection], the available physical travel directions.
sealed class MateoPageTransition {
  const MateoPageTransition._({
    required this.duration,
    required this.reverseDuration,
  });

  /// Creates a soft circular wash reveal from the selected edge.
  ///
  /// The destination remains stationary while a feathered circular gradient
  /// grows from the edge opposite [direction] until the whole viewport is
  /// visible.
  /// [MateoPageTransitionDirection.up], the default, reveals from the bottom
  /// center upward. Popping the route collapses the reveal back into the same
  /// origin.
  ///
  /// The [duration] controls the push and defaults to 600 milliseconds.
  /// [reverseDuration] controls the pop and defaults to [duration]. Zero
  /// durations are allowed. A negative duration throws an [ArgumentError].
  factory MateoPageTransition.wash({
    MateoPageTransitionDirection direction = MateoPageTransitionDirection.up,
    Duration duration = const Duration(milliseconds: 600),
    Duration? reverseDuration,
  }) {
    final resolvedReverseDuration = _resolveReverseDuration(
      duration: duration,
      reverseDuration: reverseDuration,
    );

    return _MateoWashPageTransition(
      direction: direction,
      duration: duration,
      reverseDuration: resolvedReverseDuration,
    );
  }

  /// Creates an attached push that fades only the source page.
  ///
  /// Both pages travel in [direction] as an attached strip. The visible source
  /// blends into a color wash sampled from the destination's entering edge
  /// while the incoming destination remains fully opaque. This preserves
  /// custom destination colors without exposing its content beneath the
  /// source. Popping reverses the same path and blend. A page that disables
  /// snapshotting retains the attached motion without the sampled color wash.
  ///
  /// The [duration] controls the push and defaults to 600 milliseconds.
  /// [reverseDuration] controls the pop and defaults to [duration]. Zero
  /// durations are allowed. A negative duration throws an [ArgumentError].
  factory MateoPageTransition.push({
    MateoPageTransitionDirection direction = MateoPageTransitionDirection.up,
    Duration duration = const Duration(milliseconds: 600),
    Duration? reverseDuration,
  }) {
    final resolvedReverseDuration = _resolveReverseDuration(
      duration: duration,
      reverseDuration: reverseDuration,
    );

    return _MateoPushPageTransition(
      direction: direction,
      duration: duration,
      reverseDuration: resolvedReverseDuration,
    );
  }

  static Duration _resolveReverseDuration({
    required Duration duration,
    required Duration? reverseDuration,
  }) {
    if (duration.isNegative) {
      throw ArgumentError.value(
        duration,
        'duration',
        'The transition duration cannot be negative.',
      );
    }

    final resolvedReverseDuration = reverseDuration ?? duration;
    if (resolvedReverseDuration.isNegative) {
      throw ArgumentError.value(
        reverseDuration,
        'reverseDuration',
        'The reverse transition duration cannot be negative.',
      );
    }

    return resolvedReverseDuration;
  }

  /// The duration used for the push transition.
  final Duration duration;

  /// The duration used for the pop transition.
  final Duration reverseDuration;
}

final class _MateoWashPageTransition extends MateoPageTransition {
  const _MateoWashPageTransition({
    required this.direction,
    required super.duration,
    required super.reverseDuration,
  }) : super._();

  final MateoPageTransitionDirection direction;
}

final class _MateoPushPageTransition extends MateoPageTransition {
  const _MateoPushPageTransition({
    required this.direction,
    required super.duration,
    required super.reverseDuration,
  }) : super._();

  final MateoPageTransitionDirection direction;
}
