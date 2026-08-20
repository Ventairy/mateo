part of 'mateo_color_scheme.dart';

/// Button variants available within a single Mateo button tone.
@immutable
class MateoButtonToneColorScheme {
  /// Creates the button variants available within a tone.
  const MateoButtonToneColorScheme({
    required this.primary,
    required this.secondary,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoButtonToneColorScheme.lerp(
    MateoButtonToneColorScheme a,
    MateoButtonToneColorScheme b,
    double t,
  ) => MateoButtonToneColorScheme(
    primary: MateoButtonColorScheme.lerp(a.primary, b.primary, t),
    secondary: MateoButtonColorScheme.lerp(a.secondary, b.secondary, t),
  );

  /// Primary action button pattern for this tone.
  final MateoButtonColorScheme primary;

  /// Secondary action button pattern for this tone.
  final MateoButtonColorScheme secondary;

  /// {@macro mateo_color_scheme_copy_with}
  MateoButtonToneColorScheme copyWith({
    MateoButtonColorScheme? primary,
    MateoButtonColorScheme? secondary,
  }) => MateoButtonToneColorScheme(
    primary: primary ?? this.primary,
    secondary: secondary ?? this.secondary,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoButtonToneColorScheme && primary == other.primary && secondary == other.secondary;

  @override
  int get hashCode => Object.hash(primary, secondary);
}
