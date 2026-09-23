part of 'mateo_toast_duration.dart';

/// A toast duration set by its caller.
final class MateoToastDurationCustom extends MateoToastDuration {
  /// Creates a toast timeout with a nonnegative [duration].
  MateoToastDurationCustom({required this.duration})
    : assert(!duration.isNegative, 'duration must not be negative.'),
      super._();

  /// The nonnegative time before automatic dismissal.
  final Duration duration;

  @override
  bool operator ==(Object other) => other is MateoToastDurationCustom && duration == other.duration;

  @override
  int get hashCode => Object.hash(runtimeType, duration);
}
