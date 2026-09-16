import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

import '../../foundation/mateo_elevation.dart';
import '../../foundation/mateo_rounded_shape_border/mateo_rounded_shape_border.dart';
import '../../foundation/mateo_surface_animation/mateo_surface_animation.dart';
import '../../foundation/mateo_surface_height/mateo_surface_height.dart';
import '../../foundation/mateo_surface_width/mateo_surface_width.dart';
import '../../theme/mateo_theme.dart';

part '_base_mateo_surface_content_layout.dart';
part '_base_mateo_surface_size.dart';
part '_render_base_mateo_surface_size.dart';
part '_base_mateo_surface_scroll.dart';
part '_base_mateo_surface_scroll_controller.dart';
part '_base_mateo_surface_scroll_position.dart';
part '_render_base_mateo_surface_content_layout.dart';
part 'transform_animation/_surface_transform_animation_flight_content.dart';
part 'transform_animation/_surface_transform_animation_flight_delegate.dart';
part 'transform_animation/_surface_transform_animation_flight_frame.dart';
part 'transform_animation/_surface_transform_animation_flight_layer.dart';
part 'transform_animation/_surface_transform_animation_flight_scaled_border.dart';
part 'transform_animation/effects/_surface_transform_animation_content_crossfade.dart';
part 'transform_animation/effects/_surface_transform_animation_content_effect.dart';
part 'transform_animation/effects/_surface_transform_animation_content_effects.dart';
part 'transform_animation/effects/_surface_transform_animation_content_scale.dart';
part 'transform_animation/effects/_surface_transform_animation_content_switch.dart';

@internal
class BaseMateoSurface extends StatefulWidget {
  const BaseMateoSurface({
    required this.child,
    this.animation = const .none(),
    this.color,
    this.elevation,
    this.shape = const MateoRoundedShapeBorder(radius: 0),
    this.width = const .fit(),
    this.height = const .fit(),
    this.padding,
    this.alignment,
    this.obstructionInsets,
    this.obstructionInsetsChanges,
    this.edgeEffectBuilder,
    super.key,
  }) : _scrollable = false;

  const BaseMateoSurface.scrollable({
    required this.child,
    this.animation = const .none(),
    this.color,
    this.elevation,
    this.shape = const MateoRoundedShapeBorder(radius: 0),
    this.width = const .fit(),
    this.height = const .fill(),
    this.padding,
    this.alignment,
    this.obstructionInsets,
    this.obstructionInsetsChanges,
    this.edgeEffectBuilder,
    super.key,
  }) : _scrollable = true;

  final Widget Function(Color surfaceColor, Widget viewport, ValueListenable<double>? leadingScrollDistance)?
  edgeEffectBuilder;

  final ValueGetter<EdgeInsets>? obstructionInsets;

  final Listenable? obstructionInsetsChanges;

  final bool _scrollable;

  final Widget child;

  final MateoSurfaceAnimation animation;

  final Color? color;

  final MateoElevation? elevation;

  final MateoRoundedShapeBorder shape;

  final MateoSurfaceWidth width;

  final MateoSurfaceHeight height;

  final EdgeInsetsGeometry? padding;

  final AlignmentGeometry? alignment;

  @override
  State<BaseMateoSurface> createState() => _BaseMateoSurfaceState();
}

class _BaseMateoSurfaceState extends State<BaseMateoSurface> {
  // Preserve subtree state when toggling the Morph wrapper.
  final GlobalKey _surfaceKey = GlobalKey();
  MorphTarget? _transformTarget;

  // Preserve viewport state when an effect wrapper is added or replaced.
  final GlobalKey _viewportKey = GlobalKey();

  _BaseMateoSurfaceScrollController? _scrollController;

  void _updateTransformTarget() {
    if (widget.animation case MateoSurfaceAnimationTransform(:final id)) {
      final tag = (_BaseMateoSurfaceState, id);
      if (_transformTarget?.tag == tag) return;
      _transformTarget = MorphTarget(tag: tag);
      return;
    }

    _transformTarget = null;
  }

  @override
  void initState() {
    super.initState();
    _updateTransformTarget();
  }

  @override
  void didUpdateWidget(BaseMateoSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animation != widget.animation) _updateTransformTarget();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._scrollable) _scrollController ??= _BaseMateoSurfaceScrollController();
    if (widget._scrollable && widget.height is MateoSurfaceHeightFit) {
      throw FlutterError('Scrollable Mateo surfaces do not support height: .fit(). Use .fill() or .custom(...).');
    }
    assert(widget.padding?.isNonNegative ?? true, 'padding must be nonnegative.');
    final content = _BaseMateoSurfaceContentLayout(
      obstructionInsets: widget.obstructionInsets,
      obstructionInsetsChanges: widget.obstructionInsetsChanges,
      padding: widget.padding?.resolve(Directionality.maybeOf(context)) ?? EdgeInsets.zero,
      alignment: widget.alignment?.resolve(Directionality.maybeOf(context)),
      child: widget.child,
    );
    final viewport = MorphDescendant(
      key: ValueKey(_viewportKey),
      flightBehavior: .snapshot,
      child: KeyedSubtree(
        key: _viewportKey,
        child: widget._scrollable ? _BaseMateoSurfaceScroll(controller: _scrollController!, child: content) : content,
      ),
    );
    final surfaceColor = widget.color ?? MateoTheme.of(context).colorScheme.background;
    final surface = _BaseMateoSurfaceSize(
      key: _surfaceKey,
      width: widget.width,
      height: widget.height,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: widget.shape,
          shadows: widget.elevation == null || widget.elevation!.level == 0
              ? const []
              : widget.elevation!.toShadowList(palette: MateoTheme.of(context).palette),
        ),
        child: _clipContent(
          ColoredBox(
            color: surfaceColor,
            child:
                widget.edgeEffectBuilder?.call(
                  surfaceColor,
                  viewport,
                  widget._scrollable ? _scrollController!.leadingScrollDistance : null,
                ) ??
                viewport,
          ),
        ),
      ),
    );

    return switch (widget.animation) {
      MateoSurfaceAnimationNone() => surface,
      final MateoSurfaceAnimationPop animation => _buildPop(animation, surface),
      final MateoSurfaceAnimationTransform animation => Morph(
        target: _transformTarget!,
        animateChildChanges: false,
        duration: animation.duration,
        curve: animation.curve,
        flightConfig: .custom(
          _SurfaceTransformAnimationFlightDelegate(
            color: surfaceColor,
            shape: widget.shape,
            content: viewport,
            animation: animation,
          ),
        ),
        child: surface,
      ),
    };
  }

  Widget _buildPop(MateoSurfaceAnimationPop animation, Widget surface) => Motion.list(
    interactive: true,
    effects: [
      ScaleInMotionEffect(scale: animation.beginScale, duration: animation.duration, curve: animation.curve),
      FadeInMotionEffect(duration: animation.duration, curve: animation.curve),
    ],
    child: surface,
  );

  Widget _clipContent(Widget child) {
    if (widget.shape == const MateoRoundedShapeBorder(radius: 0)) {
      return ClipRect(child: child);
    }

    return ClipPath(
      clipper: ShapeBorderClipper(shape: widget.shape, textDirection: Directionality.maybeOf(context)),
      child: child,
    );
  }
}
