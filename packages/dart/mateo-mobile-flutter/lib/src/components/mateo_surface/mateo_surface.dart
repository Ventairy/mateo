import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../bases/base_mateo_surface/base_mateo_surface.dart';
import '../../bases/base_mateo_surface/default_mateo_surface_edge_fade/default_mateo_surface_edge_fade.dart';
import '../../bases/base_mateo_surface/mateo_surface_scope.dart';
import '../../foundation/mateo_edge_effect/mateo_edge_effect.dart';
import '../../foundation/mateo_elevation.dart';
import '../../foundation/mateo_rounded_shape_border/mateo_rounded_shape_border.dart';
import '../../foundation/mateo_shape/mateo_shape.dart';
import '../../foundation/mateo_surface_animation/mateo_surface_animation.dart';
import '../../foundation/mateo_surface_height/mateo_surface_height.dart';
import '../../foundation/mateo_surface_width/mateo_surface_width.dart';

/// A Mateo background that contains content inside.
///
/// The surface fits its padded [child] by default. Use [width] and [height]
/// to fill available space or request a custom size. Parent constraints still
/// apply. [alignment] positions content without changing the sizing policy.
/// The same [shape] shapes the background and clips content and hit
/// testing. Directional padding follows the surrounding direction.
///
/// Omitted [color] uses the current Mateo background.
///
/// ```dart
/// MateoSurface(
///   shape: .capsule(),
///   padding: const EdgeInsets.all(20),
///   child: const Text('A place for your content'),
/// )
/// ```
class MateoSurface extends StatelessWidget {
  /// Creates a surface containing [child].
  ///
  /// [color] defaults to the theme background. [shape] shapes and clips
  /// the surface. [padding] must be nonnegative.
  const MateoSurface({
    required this.child,
    super.key,
    this.color,
    this.elevation,
    this.shape,
    this.width = const .fit(),
    this.height = const .fit(),
    this.padding,
    this.alignment,
    this.edgeEffect = const .none(),
    this.animation,
  }) : _scrollable = false;

  /// Creates a surface that owns vertical scrolling around [child].
  ///
  /// Height defaults to filling a bounded parent. Supply a custom [height]
  /// when the parent is unbounded. Fitted height is not supported yet. The scroll
  /// viewport expands across available width even with fitted width. Short
  /// content fills the viewport, including flexible space in a Column; long
  /// content scrolls.
  ///
  /// [padding] travels with the content. Background, [shape], and
  /// [elevation] stay fixed. [color] and [width] follow the ordinary surface.
  ///
  /// The child must support intrinsic sizing. Use ordinary box content rather
  /// than another scrolling viewport or a LayoutBuilder. This surface owns its
  /// controller independently of any surrounding primary scroll controller.
  ///
  /// ```dart
  /// const MateoSurface.scrollable(
  ///   height: .custom(320),
  ///   padding: EdgeInsets.all(20),
  ///   child: Column(
  ///     children: [Text('Welcome'), Spacer(), Text('Ready when you are')],
  ///   ),
  /// )
  /// ```
  const MateoSurface.scrollable({
    required this.child,
    super.key,
    this.color,
    this.elevation,
    this.shape,
    this.width = const .fit(),
    this.height = const .fill(),
    this.padding,
    this.alignment,
    this.edgeEffect = const .none(),
    this.animation,
  }) : _scrollable = true;

  /// The treatment applied at selected content edges, or none by default.
  ///
  /// Fades stay at the surface boundary while content scrolls underneath.
  final MateoEdgeEffect edgeEffect;

  /// The animation style for this surface.
  final MateoSurfaceAnimation? animation;

  final bool _scrollable;

  /// The content contained by the surface.
  final Widget child;

  /// The background color, or null to use the Mateo theme background.
  final Color? color;

  /// The authored lift from zero through two, including fractional values.
  ///
  /// Omit to keep the surface flat. The value validates its level on creation.
  final MateoElevation? elevation;

  /// The shape treatment used for the background and content clipping.
  final MateoShape? shape;

  /// The requested total width, including padding, subject to parent constraints.
  final MateoSurfaceWidth width;

  /// The requested total height, including padding, subject to parent constraints.
  final MateoSurfaceHeight height;

  /// The local content padding, or null for zero padding.
  final EdgeInsetsGeometry? padding;

  /// The preferred position of [child] within the padded surface.
  ///
  /// When supplied, the child receives loose constraints. Short scrollable
  /// content aligns within the viewport. Directional alignment follows the
  /// surrounding text direction. Omit to preserve the child's existing layout.
  final AlignmentGeometry? alignment;

  Widget _buildEdgeEffect(Color surfaceColor, Widget viewport, ValueListenable<double>? leadingScrollDistance) =>
      DefaultMateoSurfaceEdgeFade(
        surfaceColor: surfaceColor,
        sides: edgeEffect.at,
        child: viewport,
      );

  /// Builds the surface content and appearance.
  @override
  Widget build(BuildContext context) {
    final scope = MateoSurfaceScope.of(context);
    final resolvedShape = shape?.border ?? scope.shape ?? const MateoRoundedShapeBorder(radius: 0);
    final resolvedAnimation = animation ?? scope.animation;
    final scopedChild = MateoSurfaceScope(animation: const .none(), child: child);

    final edgeEffectBuilder = switch (edgeEffect.type) {
      .none => null,
      .fade => edgeEffect.at.isEmpty ? null : _buildEdgeEffect,
    };
    if (_scrollable) {
      return BaseMateoSurface.scrollable(
        animation: resolvedAnimation,
        color: color,
        elevation: elevation,
        shape: resolvedShape,
        width: width,
        height: height,
        padding: padding,
        alignment: alignment,
        edgeEffectBuilder: edgeEffectBuilder,
        child: scopedChild,
      );
    }
    return BaseMateoSurface(
      animation: resolvedAnimation,
      color: color,
      elevation: elevation,
      shape: resolvedShape,
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      edgeEffectBuilder: edgeEffectBuilder,
      child: scopedChild,
    );
  }
}
