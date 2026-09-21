import 'package:flutter/foundation.dart';

part 'mateo_transform_duration_auto.dart';
part 'mateo_transform_duration_custom.dart';

/// Selects the clock used by a Mateo transform.
@immutable
sealed class MateoTransformDuration {
  const MateoTransformDuration._();

  /// Uses route timing during navigation and default timing otherwise.
  const factory MateoTransformDuration.auto() = MateoTransformDurationAuto;

  /// Uses an independent transform clock with the given nonnegative [duration].
  factory MateoTransformDuration.custom({required Duration duration}) = MateoTransformDurationCustom;

  /// The explicit duration, or null when timing is selected automatically.
  Duration? get value;
}
