part of 'mateo_transform_duration.dart';

/// An independent transform clock with a fixed duration.
final class MateoTransformDurationCustom extends MateoTransformDuration {
  /// Creates an independent transform clock with a nonnegative [duration].
  MateoTransformDurationCustom({required this.duration})
    : assert(!duration.isNegative, 'duration must not be negative.'),
      super._();

  /// The nonnegative length of the transform.
  final Duration duration;

  @override
  Duration get value => duration;

  /// Whether both values configure the same duration.
  @override
  bool operator ==(Object other) => other is MateoTransformDurationCustom && duration == other.duration;

  /// The hash of this timing policy.
  @override
  int get hashCode => Object.hash(runtimeType, duration);
}
