part of 'mateo_color_scheme.dart';

/// Semantic colors for Mateo Mobile bottom sheets.
///
/// Use this role for a bottom sheet instead of borrowing a general background
/// token. This keeps bottom-sheet styling independently themeable and aligned
/// with the active app background.
@immutable
class MateoBottomSheetColorScheme {
  /// Creates semantic colors for Mateo Mobile bottom sheets.
  const MateoBottomSheetColorScheme({required this.background});

  /// {@macro mateo_color_scheme_lerp}
  factory MateoBottomSheetColorScheme.lerp(
    MateoBottomSheetColorScheme a,
    MateoBottomSheetColorScheme b,
    double t,
  ) {
    return MateoBottomSheetColorScheme(
      background: Color.lerp(a.background, b.background, t)!,
    );
  }

  /// Surface color behind bottom-sheet content.
  final Color background;

  /// {@macro mateo_color_scheme_copy_with}
  MateoBottomSheetColorScheme copyWith({Color? background}) {
    return MateoBottomSheetColorScheme(
      background: background ?? this.background,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoBottomSheetColorScheme && background == other.background;

  @override
  int get hashCode => background.hashCode;
}
