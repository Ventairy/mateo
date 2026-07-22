part of 'mateo_color_scheme.dart';

/// Button roles grouped by the component patterns used across Mateo.
///
/// Read this group when styling a concrete Mateo button pattern.
@immutable
class MateoButtonsColorScheme {
  /// Creates grouped button roles for the button patterns used across Mateo.
  const MateoButtonsColorScheme({
    required this.primary,
    required this.secondary,
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
      primary: MateoButtonColorScheme.lerp(a.primary, b.primary, t),
      secondary: MateoButtonColorScheme.lerp(a.secondary, b.secondary, t),
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

  /// Primary action button pattern.
  final MateoButtonColorScheme primary;

  /// Secondary action button pattern.
  final MateoButtonColorScheme secondary;

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
    MateoButtonColorScheme? primary,
    MateoButtonColorScheme? secondary,
    MateoButtonColorScheme? tertiary,
    MateoButtonColorScheme? text,
    MateoButtonColorScheme? danger,
    MateoButtonColorScheme? success,
    MateoSearchBarButtonColorScheme? searchBar,
    MateoFloatingButtonColorScheme? floating,
    MateoBrandedButtonColorScheme? whatsapp,
  }) {
    return MateoButtonsColorScheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
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
          primary == other.primary &&
          secondary == other.secondary &&
          tertiary == other.tertiary &&
          text == other.text &&
          danger == other.danger &&
          success == other.success &&
          searchBar == other.searchBar &&
          floating == other.floating &&
          whatsapp == other.whatsapp;

  @override
  int get hashCode => Object.hashAll([
    primary,
    secondary,
    tertiary,
    text,
    danger,
    success,
    floating,
    searchBar,
    whatsapp,
  ]);
}
