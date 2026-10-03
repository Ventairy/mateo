part of 'mateo_color_scheme.dart';

/// Semantic colors for a Mateo toggle.
@immutable
final class MateoToggleColorScheme {
  /// Creates the complete color contract for a Mateo toggle.
  const MateoToggleColorScheme({
    required this.trackOn,
    required this.trackOff,
    required this.trackDisabled,
    required this.thumbOn,
    required this.thumbOff,
    required this.thumbDisabled,
  });

  /// Track color when the toggle is on.
  final Color trackOn;

  /// Track color when the toggle is off.
  final Color trackOff;

  /// Track color when the toggle is disabled.
  final Color trackDisabled;

  /// Thumb color when the toggle is on.
  final Color thumbOn;

  /// Thumb color when the toggle is off.
  final Color thumbOff;

  /// Thumb color when the toggle is disabled.
  final Color thumbDisabled;

  /// Whether every toggle color equals the other scheme.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoToggleColorScheme &&
          trackOn == other.trackOn &&
          trackOff == other.trackOff &&
          trackDisabled == other.trackDisabled &&
          thumbOn == other.thumbOn &&
          thumbOff == other.thumbOff &&
          thumbDisabled == other.thumbDisabled;

  /// The hash of the toggle colors.
  @override
  int get hashCode => Object.hash(
    trackOn,
    trackOff,
    trackDisabled,
    thumbOn,
    thumbOff,
    thumbDisabled,
  );
}
