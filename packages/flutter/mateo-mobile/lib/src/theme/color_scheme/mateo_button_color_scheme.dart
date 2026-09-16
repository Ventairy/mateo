part of 'mateo_color_scheme.dart';

/// The surface and content colors of one button treatment.
@immutable
final class MateoButtonColorScheme {
  /// Creates a complete button treatment for available and unavailable states.
  const MateoButtonColorScheme({
    required this.background,
    required this.foreground,
    required this.backgroundDisabled,
    required this.foregroundDisabled,
  });

  /// The surface color while available.
  final Color background;

  /// The label, icon, and activity color while available.
  final Color foreground;

  /// The surface color while unavailable.
  final Color backgroundDisabled;

  /// The content color while unavailable.
  final Color foregroundDisabled;

  /// Whether every color role equals the other scheme.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoButtonColorScheme &&
          background == other.background &&
          foreground == other.foreground &&
          backgroundDisabled == other.backgroundDisabled &&
          foregroundDisabled == other.foregroundDisabled;

  /// The hash of this scheme's color roles.
  @override
  int get hashCode => Object.hash(background, foreground, backgroundDisabled, foregroundDisabled);
}
