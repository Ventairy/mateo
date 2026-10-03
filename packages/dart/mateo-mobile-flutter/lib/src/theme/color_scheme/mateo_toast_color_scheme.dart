part of 'mateo_color_scheme.dart';

/// The semantic color treatments for toast statuses.
@immutable
final class MateoToastColorScheme {
  const MateoToastColorScheme._({
    required this.neutral,
    required this.error,
    required this.warning,
    required this.info,
    required this.loading,
    required this.success,
  });

  /// The neutral toast treatment.
  final MateoToastStatusColorScheme neutral;

  /// The error toast treatment.
  final MateoToastStatusColorScheme error;

  /// The warning toast treatment.
  final MateoToastStatusColorScheme warning;

  /// The info toast treatment.
  final MateoToastStatusColorScheme info;

  /// The loading toast treatment.
  final MateoToastStatusColorScheme loading;

  /// The success toast treatment.
  final MateoToastStatusColorScheme success;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoToastColorScheme &&
          neutral == other.neutral &&
          error == other.error &&
          warning == other.warning &&
          info == other.info &&
          loading == other.loading &&
          success == other.success;

  @override
  int get hashCode => Object.hash(neutral, error, warning, info, loading, success);
}
