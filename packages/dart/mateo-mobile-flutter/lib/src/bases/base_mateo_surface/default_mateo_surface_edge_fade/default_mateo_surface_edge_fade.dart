import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../foundation/mateo_edge_effect/mateo_edge_effect_side.dart';
import '../../base_mateo_edge_fade/base_mateo_edge_fade.dart';
import '../../base_mateo_edge_fade/mateo_edge_fade_band.dart';
import '../../base_mateo_edge_fade/mateo_edge_fade_profile.dart';

part '_default_mateo_surface_edge_fade_profile.dart';

@internal
final class DefaultMateoSurfaceEdgeFade extends StatelessWidget {
  DefaultMateoSurfaceEdgeFade({
    required this.surfaceColor,
    required Set<MateoEdgeEffectSide> sides,
    required this.child,
    super.key,
  }) : sides = Set.unmodifiable(sides);

  final Color surfaceColor;
  final Set<MateoEdgeEffectSide> sides;
  final Widget child;

  static List<MateoEdgeFadeBand> resolveBands({required Size size, required Set<MateoEdgeEffectSide> sides}) =>
      _DefaultMateoSurfaceEdgeFadeProfile.resolveBands(size: size, sides: sides);

  List<MateoEdgeFadeBand> _resolveBands(Size size) => resolveBands(size: size, sides: sides);

  @override
  Widget build(BuildContext context) {
    if (sides.isEmpty) return child;
    return surfaceColor.a == 1
        ? BaseMateoEdgeFade.overlay(color: surfaceColor, resolveBands: _resolveBands, child: child)
        : BaseMateoEdgeFade.mask(resolveBands: _resolveBands, child: child);
  }
}
