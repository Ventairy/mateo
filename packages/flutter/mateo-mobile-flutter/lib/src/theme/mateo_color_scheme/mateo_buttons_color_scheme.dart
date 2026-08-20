part of 'mateo_color_scheme.dart';

/// Button roles grouped by the component patterns used across Mateo.
///
/// Read this group when styling a concrete Mateo button pattern.
@immutable
class MateoButtonsColorScheme {
  /// Creates grouped button roles for the button patterns used across Mateo.
  const MateoButtonsColorScheme({
    required this.accent,
    required this.tertiary,
    required this.text,
    required this.danger,
    required this.success,
    required this.searchBar,
    required this.floating,
    required this.whatsapp,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoButtonsColorScheme.lerp(
    MateoButtonsColorScheme a,
    MateoButtonsColorScheme b,
    double t,
  ) {
    return MateoButtonsColorScheme(
      accent: MateoButtonToneColorScheme.lerp(a.accent, b.accent, t),
      tertiary: MateoButtonColorScheme.lerp(a.tertiary, b.tertiary, t),
      text: MateoButtonColorScheme.lerp(a.text, b.text, t),
      danger: MateoButtonColorScheme.lerp(a.danger, b.danger, t),
      success: MateoButtonColorScheme.lerp(a.success, b.success, t),
      searchBar: MateoSearchBarButtonColorScheme.lerp(
        a.searchBar,
        b.searchBar,
        t,
      ),
      floating: MateoFloatingButtonColorScheme.lerp(a.floating, b.floating, t),
      whatsapp: MateoBrandedButtonColorScheme.lerp(a.whatsapp, b.whatsapp, t),
    );
  }

  /// Accent-tone button variants.
  final MateoButtonToneColorScheme accent;

  /// Tertiary action button pattern.
  final MateoButtonColorScheme tertiary;

  /// Text-only button pattern.
  final MateoButtonColorScheme text;

  /// Destructive action button pattern.
  final MateoButtonColorScheme danger;

  /// Positive action button pattern.
  final MateoButtonColorScheme success;

  /// Search bar button pattern.
  final MateoSearchBarButtonColorScheme searchBar;

  /// Floating action button pattern with dedicated border and shadow roles.
  final MateoFloatingButtonColorScheme floating;

  /// WhatsApp-branded button patterns for integrations that use that brand.
  final MateoBrandedButtonColorScheme whatsapp;

  /// {@macro mateo_color_scheme_copy_with}
  MateoButtonsColorScheme copyWith({
    MateoButtonToneColorScheme? accent,
    MateoButtonColorScheme? tertiary,
    MateoButtonColorScheme? text,
    MateoButtonColorScheme? danger,
    MateoButtonColorScheme? success,
    MateoSearchBarButtonColorScheme? searchBar,
    MateoFloatingButtonColorScheme? floating,
    MateoBrandedButtonColorScheme? whatsapp,
  }) {
    return MateoButtonsColorScheme(
      accent: accent ?? this.accent,
      tertiary: tertiary ?? this.tertiary,
      text: text ?? this.text,
      danger: danger ?? this.danger,
      success: success ?? this.success,
      searchBar: searchBar ?? this.searchBar,
      floating: floating ?? this.floating,
      whatsapp: whatsapp ?? this.whatsapp,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoButtonsColorScheme &&
          accent == other.accent &&
          tertiary == other.tertiary &&
          text == other.text &&
          danger == other.danger &&
          success == other.success &&
          searchBar == other.searchBar &&
          floating == other.floating &&
          whatsapp == other.whatsapp;

  @override
  int get hashCode => Object.hashAll([
    accent,
    tertiary,
    text,
    danger,
    success,
    floating,
    searchBar,
    whatsapp,
  ]);
}
