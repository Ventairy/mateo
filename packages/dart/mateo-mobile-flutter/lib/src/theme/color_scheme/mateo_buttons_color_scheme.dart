part of 'mateo_color_scheme.dart';

/// The semantic color treatments for Mateo buttons.
@immutable
final class MateoButtonsColorScheme {
  const MateoButtonsColorScheme._({required this.primary, required this.secondary, required this.tertiary});

  /// The prominent button colors.
  final MateoPrimaryButtonColorScheme primary;

  /// The quieter button colors.
  final MateoSecondaryButtonColorScheme secondary;

  /// The transparent button colors.
  final MateoButtonColorScheme tertiary;

  /// Whether every color role equals the other scheme.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoButtonsColorScheme &&
          primary == other.primary &&
          secondary == other.secondary &&
          tertiary == other.tertiary;

  /// The hash of this scheme's color roles.
  @override
  int get hashCode => Object.hash(primary, secondary, tertiary);
}
