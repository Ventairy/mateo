part of '../base_mateo_view_surface.dart';

final class _MateoViewSurfaceHeaderFadeProfile extends MateoEdgeFadeProfile {
  _MateoViewSurfaceHeaderFadeProfile()
    : super(
        stops: List.generate(33, (index) => index / 32),
        visibility: List.generate(33, (index) {
          final t = index / 32;
          final q = t * t * t * (10 + t * (-15 + 6 * t));
          // Blend cubic and quartic visibility for a small increase in content
          // protection, preserving the same clear endpoint and smooth release.
          return q * q * q * (.25 + .75 * q);
        }),
      );
}
