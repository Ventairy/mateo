part of 'mateo_color_scheme.dart';

/// Brand-specific button roles for a single external brand family.
///
/// This group keeps the familiar primary, secondary, and tertiary button shape
/// while allowing their colors to follow an external brand contract instead of
/// the app's primary slot.
@immutable
class MateoBrandedButtonColorScheme {
  /// Creates brand-specific button roles for one external brand family.
  const MateoBrandedButtonColorScheme({
    required this.primary,
    required this.secondary,
    required this.tertiary,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoBrandedButtonColorScheme.lerp(
    MateoBrandedButtonColorScheme a,
    MateoBrandedButtonColorScheme b,
    double t,
  ) {
    return MateoBrandedButtonColorScheme(
      primary: MateoButtonColorScheme.lerp(a.primary, b.primary, t),
      secondary: MateoButtonColorScheme.lerp(a.secondary, b.secondary, t),
      tertiary: MateoButtonColorScheme.lerp(a.tertiary, b.tertiary, t),
    );
  }

  /// Primary branded button pattern for the family.
  final MateoButtonColorScheme primary;

  /// Secondary branded button pattern for the family.
  final MateoButtonColorScheme secondary;

  /// Tertiary branded button pattern for the family.
  final MateoButtonColorScheme tertiary;

  /// {@macro mateo_color_scheme_copy_with}
  MateoBrandedButtonColorScheme copyWith({
    MateoButtonColorScheme? primary,
    MateoButtonColorScheme? secondary,
    MateoButtonColorScheme? tertiary,
  }) {
    return MateoBrandedButtonColorScheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoBrandedButtonColorScheme &&
          primary == other.primary &&
          secondary == other.secondary &&
          tertiary == other.tertiary;

  @override
  int get hashCode => Object.hash(primary, secondary, tertiary);
}
