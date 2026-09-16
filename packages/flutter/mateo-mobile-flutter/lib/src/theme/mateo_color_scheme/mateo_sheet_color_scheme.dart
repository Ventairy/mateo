part of 'mateo_color_scheme.dart';

/// Semantic colors for Mateo Mobile sheets.
///
/// Use this role for a sheet instead of borrowing a general background
/// token. This keeps sheet styling independently themeable and aligned
/// with the active app background.
@immutable
class MateoSheetColorScheme {
  /// Creates semantic colors for Mateo Mobile sheets.
  const MateoSheetColorScheme({required this.background});

  /// {@macro mateo_color_scheme_lerp}
  factory MateoSheetColorScheme.lerp(
    MateoSheetColorScheme a,
    MateoSheetColorScheme b,
    double t,
  ) {
    return MateoSheetColorScheme(
      background: Color.lerp(a.background, b.background, t)!,
    );
  }

  /// Surface color behind sheet content.
  final Color background;

  /// {@macro mateo_color_scheme_copy_with}
  MateoSheetColorScheme copyWith({Color? background}) {
    return MateoSheetColorScheme(
      background: background ?? this.background,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MateoSheetColorScheme && background == other.background;

  @override
  int get hashCode => background.hashCode;
}
