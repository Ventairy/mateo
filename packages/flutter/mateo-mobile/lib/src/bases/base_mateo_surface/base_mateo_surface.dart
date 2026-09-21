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
import '../base_mateo_transform/base_mateo_transform.dart';
import 'mateo_surface_obstruction.dart';

part '_base_mateo_surface_content_layer.dart';
part '_base_mateo_surface_content_layout.dart';
part '_base_mateo_surface_scroll.dart';
part '_base_mateo_surface_scroll_controller.dart';
part '_base_mateo_surface_scroll_position.dart';
part '_base_mateo_surface_size.dart';
part '_render_base_mateo_surface_content_layout.dart';
part '_render_base_mateo_surface_size.dart';

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
    this.obstruction,
    this.edgeEffectBuilder,
    this.paintBackground = true,
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
    this.obstruction,
    this.edgeEffectBuilder,
    this.paintBackground = true,
    super.key,
  }) : _scrollable = true;

  final Widget Function(Color surfaceColor, Widget viewport, ValueListenable<double>? leadingScrollDistance)?
  edgeEffectBuilder;

  final bool paintBackground;

  final MateoSurfaceObstruction? obstruction;

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
  // Preserve viewport state when an effect wrapper is added or replaced.
  final GlobalKey _viewportKey = GlobalKey();

  _BaseMateoSurfaceScrollController? _scrollController;

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
      obstruction: widget.obstruction,
      padding: widget.padding?.resolve(Directionality.maybeOf(context)) ?? EdgeInsets.zero,
      alignment: widget.alignment?.resolve(Directionality.maybeOf(context)),
      child: widget.child,
    );
    final viewport = KeyedSubtree(
      key: _viewportKey,
      child: widget._scrollable ? _BaseMateoSurfaceScroll(controller: _scrollController!, child: content) : content,
    );
    final surfaceColor = widget.color ?? MateoTheme.of(context).colorScheme.background;
    Widget withEdgeEffect(Widget child) =>
        widget.edgeEffectBuilder?.call(
          surfaceColor,
          child,
          widget._scrollable ? _scrollController!.leadingScrollDistance : null,
        ) ??
        child;
    final capturedContent = MorphDescendant(
      key: const ValueKey('Mateo surface transform content'),
      flightBehavior: .snapshot,
      child: _clipContent(withEdgeEffect(viewport)),
    );
    final presentation = widget.paintBackground
        ? Stack(
            fit: StackFit.passthrough,
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: _clipContent(ColoredBox(color: surfaceColor)),
              ),
              capturedContent,
            ],
          )
        : capturedContent;
    final surface = _BaseMateoSurfaceSize(
      key: _surfaceKey,
      width: widget.width,
      height: widget.height,
      child: widget.paintBackground
          ? DecoratedBox(
              decoration: ShapeDecoration(
                shape: widget.shape,
                shadows: widget.elevation == null || widget.elevation!.level == 0
                    ? const []
                    : widget.elevation!.toShadowList(
                        palette: MateoTheme.of(context).palette,
                      ),
              ),
              child: presentation,
            )
          : presentation,
    );

    return _buildAnimation(
      surface: surface,
      content: capturedContent,
      color: surfaceColor,
    );
  }

  Widget _buildAnimation({
    required Widget surface,
    required Widget content,
    required Color color,
  }) {
    return switch (widget.animation) {
      MateoSurfaceAnimationNone() => surface,
      final MateoSurfaceAnimationPop animation => _buildPopAnimation(animation: animation, child: surface),
      final MateoSurfaceAnimationTransform animation => _buildTransformAnimation(
        animation: animation,
        surface: surface,
        content: content,
        color: color,
      ),
    };
  }

  Widget _buildTransformAnimation({
    required MateoSurfaceAnimationTransform animation,
    required Widget surface,
    required Widget content,
    required Color color,
  }) {
    final targets = BaseMateoTransformTargets(animation.target);
    final shape = animation.shape?.border ?? widget.shape;
    return BaseMateoTransform(
      color: color,
      content: content,
      candidates: [
        BaseMateoTransformCandidate.surface(
          target: targets.surfaceToSurface,
          shape: shape,
          contentEffects: animation.contentEffects,
        ),
        BaseMateoTransformCandidate.view(
          target: targets.surfaceToView,
          shape: shape,
          contentEffects: animation.contentEffects,
        ),
      ],
      child: surface,
    );
  }

  Widget _buildPopAnimation({required MateoSurfaceAnimationPop animation, required Widget child}) {
    return Motion.list(
      interactive: true,
      effects: [
        ScaleInMotionEffect(scale: animation.beginScale, duration: animation.duration, curve: animation.curve),
        FadeInMotionEffect(duration: animation.duration, curve: animation.curve),
      ],
      child: child,
    );
  }

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
