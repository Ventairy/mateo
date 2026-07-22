part of 'mateo_color_scheme.dart';

/// Semantic colors for Mateo Mobile bottom sheets.
///
/// Use these roles for a bottom sheet instead of
/// borrowing general background or border tokens. This keeps bottom-sheet
/// styling independently themeable and aligned with the active app background
/// and neutral palette.
@immutable
class MateoBottomSheetColorScheme {
  /// Creates semantic colors for Mateo Mobile bottom sheets.
  const MateoBottomSheetColorScheme({
    required this.background,
    required this.handle,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoBottomSheetColorScheme.lerp(
    MateoBottomSheetColorScheme a,
    MateoBottomSheetColorScheme b,
    double t,
  ) {
    return MateoBottomSheetColorScheme(
      background: Color.lerp(a.background, b.background, t)!,
      handle: Color.lerp(a.handle, b.handle, t)!,
    );
  }

  /// Surface color behind bottom-sheet content.
  final Color background;

  /// Subtle color for the draggable handle on a bottom-sheet surface.
  final Color handle;

  /// {@macro mateo_color_scheme_copy_with}
  MateoBottomSheetColorScheme copyWith({Color? background, Color? handle}) {
    return MateoBottomSheetColorScheme(
      background: background ?? this.background,
      handle: handle ?? this.handle,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoBottomSheetColorScheme &&
          background == other.background &&
          handle == other.handle;

  @override
  int get hashCode => Object.hash(background, handle);
}
