part of 'mateo_toast_duration.dart';

/// A toast without an automatic timeout.
final class MateoToastDurationUntilDismissed extends MateoToastDuration {
  /// Creates persistent toast timing.
  const MateoToastDurationUntilDismissed() : super._();

  @override
  bool operator ==(Object other) => other is MateoToastDurationUntilDismissed;

  @override
  int get hashCode => runtimeType.hashCode;
}
