import 'package:flutter/foundation.dart';

part 'mateo_toast_duration_auto.dart';
part 'mateo_toast_duration_custom.dart';
part 'mateo_toast_duration_until_dismissed.dart';

/// Selects how long a toast remains visible before automatic dismissal.
@immutable
sealed class MateoToastDuration {
  const new _();

  /// Estimates reading time from the toast message, between 2.5 and 8 seconds.
  const factory auto() = MateoToastDurationAuto;

  /// Keeps the toast visible until it is dismissed or replaced.
  const factory untilDismissed() = MateoToastDurationUntilDismissed;

  /// Dismisses the toast after the given nonnegative [duration].
  factory custom({required Duration duration}) = MateoToastDurationCustom;
}
