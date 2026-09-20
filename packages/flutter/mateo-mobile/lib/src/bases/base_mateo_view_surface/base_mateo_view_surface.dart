import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

import '../../foundation/mateo_edge_effect/mateo_edge_effect.dart';
import '../../foundation/mateo_edge_effect/mateo_edge_effect_side.dart';
import '../../foundation/mateo_elevation.dart';
import '../../foundation/mateo_navigator_observer.dart';
import '../../foundation/mateo_rounded_shape_border/mateo_rounded_shape_border.dart';
import '../../foundation/mateo_surface_animation/mateo_surface_animation.dart';
import '../base_mateo_edge_fade/mateo_edge_fade_band.dart';
import '../base_mateo_edge_fade/mateo_edge_fade_painter.dart';
import '../base_mateo_edge_fade/mateo_edge_fade_profile.dart';
import '../base_mateo_page_route/base_mateo_page_route.dart';
import '../base_mateo_surface/base_mateo_surface.dart';
import '../base_mateo_surface/default_mateo_surface_edge_fade/default_mateo_surface_edge_fade.dart';
import '../base_mateo_surface/mateo_surface_scope.dart';
import '../base_mateo_view/base_mateo_view.dart';

part 'mateo_view_surface_edge_fade/_mateo_view_surface_edge_fade.dart';
part 'mateo_view_surface_edge_fade/_mateo_view_surface_edge_fade_painter.dart';
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

  EdgeInsets _resolvePadding(MateoViewLayoutScope view, TextDirection direction) =>
      padding?.resolve(direction) ??
      view.padding.copyWith(
        top: view.hasHeader && view.reserveHeaderSpace ? view.defaultContentGap : view.padding.top,
        bottom: view.hasFooter ? view.defaultContentGap : view.padding.bottom,
      );

  @override
  Widget build(BuildContext context) {
    final scope = MateoSurfaceScope.of(context);
    final shape = this.shape ?? scope.shape ?? const MateoRoundedShapeBorder(radius: 0);
    final animation = this.animation ?? scope.animation;
    final navigator = Navigator.maybeOf(context);
    final observer = navigator == null ? null : MorphNavigatorObserver.maybeOfNavigator(navigator);
    final sheetToViewTarget = observer is MateoNavigatorObserver ? observer.sheetToViewTarget : null;
    final route = ModalRoute.of(context);
    final animationStartup = route is BaseMateoPageRoute && !route.shouldAnimateSurfaceEntrance
        ? MotionStartup.skip
        : MotionStartup.play;

    final scopedChild = MateoSurfaceScope(animation: const .none(), child: child);
    final view = MateoViewLayoutScope.maybeOf(context);
    assert(view != null, 'BaseMateoViewSurface requires a BaseMateoView.');

    final resolvedPadding = _resolvePadding(view!, Directionality.of(context));

    final Widget Function(Color, Widget, ValueListenable<double>?)? edgeEffectBuilder = switch (edgeEffect.type) {
      .none => null,
      .fade =>
        edgeEffect.at.isEmpty
            ? null
            : (surfaceColor, viewport, leadingScrollDistance) => _MateoViewSurfaceEdgeFade(
                surfaceColor: surfaceColor,
                contentTopPadding: resolvedPadding.top,
                leadingScrollDistance: leadingScrollDistance,
                sides: edgeEffect.at,
                child: viewport,
              ),
    };

    if (scrollable) {
      return BaseMateoSurface.scrollable(
        width: const .fill(),
        height: const .fill(),
        animation: animation,
        sheetToViewTarget: sheetToViewTarget,
        animationStartup: animationStartup,
        contentGroup: view.contentGroup,
        color: color,
        elevation: elevation,
        shape: shape,
        padding: resolvedPadding,
        obstruction: view.obstruction,
        alignment: alignment,
        edgeEffectBuilder: edgeEffectBuilder,
        child: scopedChild,
      );
    }

    return BaseMateoSurface(
      width: const .fill(),
      height: view.fitHeight ? const .fit() : const .fill(),
      animation: animation,
      sheetToViewTarget: sheetToViewTarget,
      animationStartup: animationStartup,
      contentGroup: view.contentGroup,
      color: color,
      elevation: elevation,
      shape: shape,
      padding: resolvedPadding,
      obstruction: view.obstruction,
      alignment: alignment,
      edgeEffectBuilder: edgeEffectBuilder,
      child: scopedChild,
    );
  }
}
