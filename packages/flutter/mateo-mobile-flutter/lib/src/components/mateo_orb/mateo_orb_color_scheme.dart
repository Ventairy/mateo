import 'package:flutter/material.dart';

/// Surface and vapor colors used by the Mateo orb.
///
/// The [background] color anchors the orb while [smoke] colors its lighter,
/// fluid regions. The orb derives its intermediate tones and three-dimensional
/// lighting from these two roles.
@immutable
class MateoOrbColorScheme {
  /// Creates a complete color scheme for the Mateo orb.
  const MateoOrbColorScheme({
    required this.background,
    required this.smoke,
  });

  /// Interpolates every color role between [a] and [b].
  factory MateoOrbColorScheme.lerp(
    MateoOrbColorScheme a,
    MateoOrbColorScheme b,
    double t,
  ) => MateoOrbColorScheme(
    background: Color.lerp(a.background, b.background, t)!,
    smoke: Color.lerp(a.smoke, b.smoke, t)!,
  );

  /// Base color of the orb surface.
  final Color background;

  /// Light color of the drifting vapor.
  final Color smoke;

  /// Returns a copy with the supplied values replaced.
  MateoOrbColorScheme copyWith({Color? background, Color? smoke}) {
    return MateoOrbColorScheme(
      background: background ?? this.background,
      smoke: smoke ?? this.smoke,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MateoOrbColorScheme && background == other.background && smoke == other.smoke;

  @override
  int get hashCode => Object.hash(background, smoke);
}
