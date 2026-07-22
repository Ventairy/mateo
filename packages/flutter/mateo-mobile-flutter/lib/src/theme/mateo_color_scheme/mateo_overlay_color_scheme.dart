part of 'mateo_color_scheme.dart';

/// Overlay-specific roles that complement shared surface tokens.
///
/// Use this group for overlay chrome such as modal scrims when app UI needs
/// overlay behavior instead of a normal surface or background role.
@immutable
class MateoOverlayColorScheme {
  /// Creates overlay-specific roles that complement shared surface tokens.
  const MateoOverlayColorScheme({required this.scrim});

  /// {@macro mateo_color_scheme_lerp}
  factory MateoOverlayColorScheme.lerp(
    MateoOverlayColorScheme a,
    MateoOverlayColorScheme b,
    double t,
  ) {
    return MateoOverlayColorScheme(scrim: Color.lerp(a.scrim, b.scrim, t)!);
  }

  /// Scrim color applied behind modal or elevated overlay content.
  final Color scrim;

  /// {@macro mateo_color_scheme_copy_with}
  MateoOverlayColorScheme copyWith({Color? scrim}) {
    return MateoOverlayColorScheme(scrim: scrim ?? this.scrim);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoOverlayColorScheme && scrim == other.scrim;

  @override
  int get hashCode => scrim.hashCode;
}
