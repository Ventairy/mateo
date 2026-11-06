part of '../base_mateo_view_surface.dart';

final class _MateoViewSurfaceFooterFadeProfile extends MateoEdgeFadeProfile {
  new()
    : super(
        stops: List.generate(33, (index) => index / 32),
        visibility: List.generate(33, (index) {
          final t = index / 32;
          return t * t * t * (10 + t * (-15 + 6 * t));
        }),
      );
}
