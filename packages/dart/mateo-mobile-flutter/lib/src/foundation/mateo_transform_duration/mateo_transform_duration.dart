import 'package:flutter/foundation.dart';

part 'mateo_transform_duration_auto.dart';
part 'mateo_transform_duration_custom.dart';

/// Selects the clock used by a Mateo transform.
@immutable
sealed class MateoTransformDuration {
  const new _();

  /// Uses route timing during navigation and default timing otherwise.
  const factory auto() = MateoTransformDurationAuto;

  /// Uses an independent transform clock with the given nonnegative [duration].
  factory custom({required Duration duration}) = MateoTransformDurationCustom;

  /// The explicit duration, or null when timing is selected automatically.
  Duration? get value;
}
