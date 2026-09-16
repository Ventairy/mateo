import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../../bases/base_mateo_view_surface/base_mateo_view_surface.dart';
import '../../../../foundation/mateo_edge_effect/mateo_edge_effect.dart';
import '../../../../foundation/mateo_elevation.dart';
import '../../../../foundation/mateo_surface_animation/mateo_surface_animation.dart';
import '../../mateo_view.dart';
import 'mateo_view_surface_shape.dart';

/// The content surface supplied to [MateoView.surface].
///
/// Inherits horizontal view padding and keeps content clear of its header and
/// footer. Where a header or footer is absent, reserves the view’s padding at
/// that edge instead. Explicit surface padding adds spacing inside this clearance.
///
/// ```dart
/// const MateoView(
///   surface: MateoViewSurface(child: Text('A place for your content')),
/// )
/// ```
class MateoViewSurface extends StatelessWidget {
  /// Creates a surface containing [child].
  ///
  /// [color] defaults to the theme background. [shape] shapes and clips
  /// the surface. [padding] must be nonnegative.
  const MateoViewSurface({
    required this.child,
    super.key,
    this.color,
    this.elevation,
    this.shape,
    this.padding,
    this.alignment,
    this.edgeEffect = const .none(),
    this.animation,
  }) : _scrollable = false;

  /// Creates a surface that owns vertical scrolling around [child].
  ///
  /// Short content fills the view's viewport, including flexible space in a
  /// Column; long content scrolls.
  ///
  /// [padding] travels with the content. Background, [shape], and
  /// [elevation] stay fixed. [color] follows the ordinary surface.
  ///
  /// The child must support intrinsic sizing. Use ordinary box content rather
  /// than another scrolling viewport or a LayoutBuilder. This surface owns its
  /// controller independently of any surrounding primary scroll controller.
  ///
  /// ```dart
  /// const MateoView(
  ///   surface: MateoViewSurface.scrollable(
  ///     child: Column(
  ///       children: [Text('Welcome'), Spacer(), Text('Ready when you are')],
  ///     ),
  ///   ),
  /// )
  /// ```
  const MateoViewSurface.scrollable({
    required this.child,
    super.key,
    this.color,
    this.elevation,
    this.shape,
    this.padding,
    this.alignment,
    this.edgeEffect = const .none(),
    this.animation,
  }) : _scrollable = true;

  /// The treatment applied at selected content edges, or none by default.
  ///
  /// This automatically adapts the effect to the obstructions at the edges such as header and footer
  final MateoEdgeEffect edgeEffect;

  /// The animation style for this surface.
  final MateoSurfaceAnimation? animation;

  final bool _scrollable;

  @internal
  // Internal layout coordination, not a consumer-facing property.
  // ignore: public_member_api_docs
  bool get isScrollable => _scrollable;

  /// The content contained by the surface.
  final Widget child;

  /// The background color, or null to use the Mateo theme background.
  final Color? color;

  /// The authored lift from zero through two, including fractional values.
  ///
  /// Omit to keep the surface flat. The value validates its level on creation.
  final MateoElevation? elevation;

  /// The shape treatment used for the background and content clipping.
  final MateoViewSurfaceShape? shape;

  /// The local content padding, or null to inherit horizontal view padding.
  final EdgeInsetsGeometry? padding;

  /// The preferred position of [child] within the full padded surface.
  ///
  /// When supplied, the child receives loose constraints and keeps this position
  /// unless it overlaps the view header or footer. Only the required clearance
  /// is added. Short scrollable content aligns within the viewport; long content
  /// can scroll behind the header. Directional alignment follows Directionality.
  ///
  /// Omit to lay out content between the header and footer. Alignment
  /// measures the immediate child, not descendants inside Center or Stack, and
  /// does not account for paint transforms authored inside that child.
  final AlignmentGeometry? alignment;

  /// Builds the surface content and appearance.
  @override
  Widget build(BuildContext context) {
    return BaseMateoViewSurface(
      scrollable: _scrollable,
      shape: shape?.border,
      animation: animation,
      color: color,
      elevation: elevation,
      padding: padding,
      alignment: alignment,
      edgeEffect: edgeEffect,
      child: child,
    );
  }
}
