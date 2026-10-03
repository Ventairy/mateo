part of 'default_mateo_surface_edge_fade.dart';

final class _DefaultMateoSurfaceEdgeFadeProfile {
  static const _coverage = 0.15;
  static const _segmentCount = 32;

  // Zero slope and curvature at both ends. With 32 linear segments, the
  // maximum interpolation error is bounded by (10√3/3)/(8×32²) < 0.000705.
  static final _profile = MateoEdgeFadeProfile(
    stops: List.generate(_segmentCount + 1, (index) => index / _segmentCount),
    visibility: List.generate(_segmentCount + 1, (index) {
      final progress = index / _segmentCount;
      return progress * progress * progress * (10 + progress * (-15 + 6 * progress));
    }),
  );

  static List<MateoEdgeFadeBand> resolveBands({required Size size, required Set<MateoEdgeEffectSide> sides}) {
    final extent = size.height * _coverage;
    if (size.isEmpty || extent == 0) return const [];
    return [
      if (sides.contains(MateoEdgeEffectSide.top)) .top(extent: extent, profile: _profile),
      if (sides.contains(MateoEdgeEffectSide.bottom)) .bottom(extent: extent, profile: _profile),
    ];
  }
}
