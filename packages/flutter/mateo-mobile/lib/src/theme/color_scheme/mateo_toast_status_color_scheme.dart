part of 'mateo_color_scheme.dart';

/// The surface, message, and icon colors of a toast status.
@immutable
final class MateoToastStatusColorScheme {
  /// Creates the complete color treatment for a toast status.
  const MateoToastStatusColorScheme({required this.background, required this.foreground, required this.icon});

  /// The background color.
  final Color background;

  /// The foreground color.
  final Color foreground;

  /// The icon color.
  final Color icon;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoToastStatusColorScheme &&
          background == other.background &&
          foreground == other.foreground &&
          icon == other.icon;

  @override
  int get hashCode => Object.hash(background, foreground, icon);
}
