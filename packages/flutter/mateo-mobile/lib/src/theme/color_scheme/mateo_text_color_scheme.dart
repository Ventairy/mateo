part of 'mateo_color_scheme.dart';

/// The shared text color roles in a Mateo scheme.
@immutable
final class MateoTextColorScheme {
  const MateoTextColorScheme._({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.profit,
  });

  /// The highest-emphasis text color.
  final Color primary;

  /// The supporting text color.
  final Color secondary;

  /// The low-emphasis text color; unsuitable for normal body text on white.
  final Color tertiary;

  /// The money or profit accent; unsuitable for normal body text on white.
  final Color profit;

  /// Whether every color equals the other group's color.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoTextColorScheme &&
          primary == other.primary &&
          secondary == other.secondary &&
          tertiary == other.tertiary &&
          profit == other.profit;

  /// The hash of this group's colors.
  @override
  int get hashCode => Object.hash(primary, secondary, tertiary, profit);
}
