import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/mateo_edge_effect/mateo_edge_effect.dart';
import '../../foundation/mateo_edge_effect/mateo_edge_effect_side.dart';
import '../../foundation/mateo_elevation.dart';
import '../../foundation/mateo_rounded_shape_border/mateo_rounded_shape_border.dart';
import '../../foundation/mateo_surface_animation/mateo_surface_animation.dart';
import '../base_mateo_edge_fade/base_mateo_edge_fade.dart';
import '../base_mateo_edge_fade/mateo_edge_fade_band.dart';
import '../base_mateo_edge_fade/mateo_edge_fade_profile.dart';
import '../base_mateo_surface/base_mateo_surface.dart';
import '../base_mateo_surface/default_mateo_surface_edge_fade/default_mateo_surface_edge_fade.dart';
import '../base_mateo_surface/mateo_surface_scope.dart';
import '../base_mateo_view/base_mateo_view.dart';

part 'mateo_view_surface_edge_fade/_mateo_view_surface_edge_fade.dart';
part 'mateo_view_surface_edge_fade/_mateo_view_surface_footer_fade_profile.dart';
part 'mateo_view_surface_edge_fade/_mateo_view_surface_header_fade_profile.dart';

@internal
class BaseMateoViewSurface extends StatelessWidget {
  const BaseMateoViewSurface({
    required this.child,
    required this.scrollable,
    this.shape,
    this.animation,
    this.color,
    this.elevation,
    this.padding,
    this.alignment,
    this.edgeEffect = const .none(),
    super.key,
  });

  final Widget child;
  final bool scrollable;
  final MateoRoundedShapeBorder? shape;
  final MateoSurfaceAnimation? animation;
  final Color? color;
  final MateoElevation? elevation;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final MateoEdgeEffect edgeEffect;

  Widget _buildFadeEdgeEffect(Color surfaceColor, Widget viewport, ValueListenable<double>? leadingScrollDistance) =>
      _MateoViewSurfaceEdgeFade(
        surfaceColor: surfaceColor,
        leadingScrollDistance: leadingScrollDistance,
        sides: edgeEffect.at,
        child: viewport,
      );

  @override
  Widget build(BuildContext context) {
    final scope = MateoSurfaceScope.of(context);
    final shape = this.shape ?? scope.shape ?? const MateoRoundedShapeBorder(radius: 0);
    final animation = this.animation ?? scope.animation;

    final scopedChild = MateoSurfaceScope(animation: const .none(), child: child);
    final view = MateoViewLayoutScope.maybeOf(context);
    assert(view != null, 'BaseMateoViewSurface requires a BaseMateoView.');

    final edgeEffectBuilder = switch (edgeEffect.type) {
      .none => null,
      .fade => edgeEffect.at.isEmpty ? null : _buildFadeEdgeEffect,
    };

    if (scrollable) {
      return BaseMateoSurface.scrollable(
        width: const .fill(),
        height: const .fill(),
        animation: animation,
        color: color,
        elevation: elevation,
        shape: shape,
        padding: padding ?? view!.padding.copyWith(top: 0, bottom: 0),
        obstructionInsets: () => view.obstructionInsets,
        obstructionInsetsChanges: view!.obstructionInsetsChanges,
        alignment: alignment,
        edgeEffectBuilder: edgeEffectBuilder,
        child: scopedChild,
      );
    }

    return BaseMateoSurface(
      width: const .fill(),
      height: view!.fitHeight ? const .fit() : const .fill(),
      animation: animation,
      color: color,
      elevation: elevation,
      shape: shape,
      padding: padding ?? view.padding.copyWith(top: 0, bottom: 0),
      obstructionInsets: () => view.obstructionInsets,
      obstructionInsetsChanges: view.obstructionInsetsChanges,
      alignment: alignment,
      edgeEffectBuilder: edgeEffectBuilder,
      child: scopedChild,
    );
  }
}
