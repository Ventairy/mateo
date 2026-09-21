part of 'mateo_transform_duration.dart';

/// Automatic transform timing selected from the transition context.
final class MateoTransformDurationAuto extends MateoTransformDuration {
  /// Creates automatic transform timing.
  const MateoTransformDurationAuto() : super._();

  @override
  Duration? get value => null;

  /// Whether both values select automatic transform timing.
  @override
  bool operator ==(Object other) => other is MateoTransformDurationAuto;

  /// The hash of this timing policy.
  @override
  int get hashCode => runtimeType.hashCode;
}
