part of 'mateo_palette.dart';

/// A step-9 anchor color with 12 immutable shades, indexed from 1 to 12.
///
/// Pass `palette.red` directly to a Flutter color parameter to use its anchor.
/// Select `palette.red[3]` for a lighter shade or `palette.red[12]` for a darker
/// shade. Color operations such as `withValues` return a regular [Color].
@immutable
final class MateoColorScale extends Color {
  factory MateoColorScale._(List<Color> colors) {
    if (colors.length != 12) {
      throw ArgumentError.value(colors.length, 'colors.length', 'must contain exactly 12 colors');
    }
    return MateoColorScale._immutable(List.unmodifiable(colors));
  }

  MateoColorScale._immutable(this.colors)
    : super.from(
        alpha: colors[8].a,
        red: colors[8].r,
        green: colors[8].g,
        blue: colors[8].b,
        colorSpace: colors[8].colorSpace,
      );

  /// The immutable colors in ascending step order.
  final List<Color> colors;

  /// The color at the one-based [step].
  ///
  /// Throws [RangeError] when [step] is outside 1 through 12.
  Color operator [](int step) {
    RangeError.checkValueInInterval(step, 1, 12, 'step');
    return colors[step - 1];
  }

  /// Whether all 12 colors equal the other scale's colors.
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MateoColorScale && listEquals(colors, other.colors);

  /// The hash of all 12 colors.
  @override
  int get hashCode => Object.hashAll(colors);
}
