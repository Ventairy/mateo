part of 'mateo_toast_duration.dart';

/// A toast duration estimated from its message length.
final class MateoToastDurationAuto extends MateoToastDuration {
  /// Creates automatic toast timing.
  const MateoToastDurationAuto() : super._();

  @override
  bool operator ==(Object other) => other is MateoToastDurationAuto;

  @override
  int get hashCode => runtimeType.hashCode;
}
