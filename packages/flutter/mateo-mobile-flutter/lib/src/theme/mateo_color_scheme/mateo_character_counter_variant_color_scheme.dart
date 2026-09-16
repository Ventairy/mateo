part of 'mateo_color_scheme.dart';

/// Semantic colors for a Mateo character-counter variant.
@immutable
class MateoCharacterCounterVariantColorScheme {
  /// Creates the complete color contract for a character-counter variant.
  const MateoCharacterCounterVariantColorScheme({
    required this.background,
    required this.backgroundDisabled,
    required this.foreground,
    required this.foregroundDisabled,
    required this.foregroundReject,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoCharacterCounterVariantColorScheme.lerp(
    MateoCharacterCounterVariantColorScheme a,
    MateoCharacterCounterVariantColorScheme b,
    double t,
  ) => MateoCharacterCounterVariantColorScheme(
    background: Color.lerp(a.background, b.background, t)!,
    backgroundDisabled: Color.lerp(a.backgroundDisabled, b.backgroundDisabled, t)!,
    foreground: Color.lerp(a.foreground, b.foreground, t)!,
    foregroundDisabled: Color.lerp(a.foregroundDisabled, b.foregroundDisabled, t)!,
    foregroundReject: Color.lerp(a.foregroundReject, b.foregroundReject, t)!,
  );

  /// Background color behind the counter.
  final Color background;

  /// Background color behind a disabled counter.
  final Color backgroundDisabled;

  /// Counter text color.
  final Color foreground;

  /// Counter text color while disabled.
  final Color foregroundDisabled;

  /// Counter text color after input exceeds its limit.
  final Color foregroundReject;

  /// {@macro mateo_color_scheme_copy_with}
  MateoCharacterCounterVariantColorScheme copyWith({
    Color? background,
    Color? backgroundDisabled,
    Color? foreground,
    Color? foregroundDisabled,
    Color? foregroundReject,
  }) => MateoCharacterCounterVariantColorScheme(
    background: background ?? this.background,
    backgroundDisabled: backgroundDisabled ?? this.backgroundDisabled,
    foreground: foreground ?? this.foreground,
    foregroundDisabled: foregroundDisabled ?? this.foregroundDisabled,
    foregroundReject: foregroundReject ?? this.foregroundReject,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoCharacterCounterVariantColorScheme &&
          background == other.background &&
          backgroundDisabled == other.backgroundDisabled &&
          foreground == other.foreground &&
          foregroundDisabled == other.foregroundDisabled &&
          foregroundReject == other.foregroundReject;

  @override
  int get hashCode => Object.hash(
    background,
    backgroundDisabled,
    foreground,
    foregroundDisabled,
    foregroundReject,
  );
}
