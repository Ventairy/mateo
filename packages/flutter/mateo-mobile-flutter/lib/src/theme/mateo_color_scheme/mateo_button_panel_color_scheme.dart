part of 'mateo_color_scheme.dart';

/// Semantic colors for Mateo Mobile button panels.
@immutable
class MateoButtonPanelColorScheme {
  /// Creates the complete color contract for a button panel.
  const MateoButtonPanelColorScheme({
    required this.background,
    required this.border,
    required this.shadow,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoButtonPanelColorScheme.lerp(
    MateoButtonPanelColorScheme a,
    MateoButtonPanelColorScheme b,
    double t,
  ) => MateoButtonPanelColorScheme(
    background: Color.lerp(a.background, b.background, t)!,
    border: Color.lerp(a.border, b.border, t)!,
    shadow: Color.lerp(a.shadow, b.shadow, t)!,
  );

  /// Surface color behind the grouped buttons.
  final Color background;

  /// Border color separating the panel from surrounding content.
  final Color border;

  /// Shadow color separating the floating panel from underlying content.
  final Color shadow;

  /// {@macro mateo_color_scheme_copy_with}
  MateoButtonPanelColorScheme copyWith({
    Color? background,
    Color? border,
    Color? shadow,
  }) => MateoButtonPanelColorScheme(
    background: background ?? this.background,
    border: border ?? this.border,
    shadow: shadow ?? this.shadow,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoButtonPanelColorScheme &&
          background == other.background &&
          border == other.border &&
          shadow == other.shadow;

  @override
  int get hashCode => Object.hash(background, border, shadow);
}
