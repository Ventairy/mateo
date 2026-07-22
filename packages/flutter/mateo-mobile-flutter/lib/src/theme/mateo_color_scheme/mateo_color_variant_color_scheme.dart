part of 'mateo_color_scheme.dart';

/// A reusable solid color variant and its foreground.
@immutable
class MateoColorVariantColorScheme {
  /// Creates a complete solid color variant.
  const MateoColorVariantColorScheme({
    required this.solid,
    required this.onSolid,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoColorVariantColorScheme.lerp(
    MateoColorVariantColorScheme a,
    MateoColorVariantColorScheme b,
    double t,
  ) => MateoColorVariantColorScheme(
    solid: Color.lerp(a.solid, b.solid, t)!,
    onSolid: Color.lerp(a.onSolid, b.onSolid, t)!,
  );

  /// Solid color for this variant.
  final Color solid;

  /// Foreground color placed on [solid].
  final Color onSolid;

  /// {@macro mateo_color_scheme_copy_with}
  MateoColorVariantColorScheme copyWith({Color? solid, Color? onSolid}) =>
      MateoColorVariantColorScheme(
        solid: solid ?? this.solid,
        onSolid: onSolid ?? this.onSolid,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoColorVariantColorScheme &&
          solid == other.solid &&
          onSolid == other.onSolid;

  @override
  int get hashCode => Object.hash(solid, onSolid);
}
