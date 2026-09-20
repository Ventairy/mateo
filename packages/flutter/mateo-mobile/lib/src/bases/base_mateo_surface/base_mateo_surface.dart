import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

import '../../foundation/mateo_elevation.dart';
import '../../foundation/mateo_rounded_shape_border/mateo_rounded_shape_border.dart';
import '../../foundation/mateo_sheet_to_view_transition.dart';
import '../../foundation/mateo_surface_animation/mateo_surface_animation.dart';
import '../../foundation/mateo_surface_animation/mateo_surface_transform_target.dart';
import '../../foundation/mateo_surface_height/mateo_surface_height.dart';
import '../../foundation/mateo_surface_width/mateo_surface_width.dart';
import '../../theme/mateo_theme.dart';
import 'mateo_surface_obstruction.dart';

part '_base_mateo_surface_content_layer.dart';
part '_base_mateo_surface_content_layout.dart';
part '_base_mateo_surface_scroll.dart';
part '_base_mateo_surface_scroll_controller.dart';
part '_base_mateo_surface_scroll_position.dart';
part '_base_mateo_surface_size.dart';
part '_render_base_mateo_surface_content_layout.dart';
part '_render_base_mateo_surface_size.dart';
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
    this.obstruction,
    this.edgeEffectBuilder,
    this.contentGroup,
    this.sheetToViewTarget,
    this.animationStartup = .play,
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
    this.contentGroup,
    this.sheetToViewTarget,
    this.animationStartup = .play,
    super.key,
  }) : _scrollable = true;

  final Widget Function(Color surfaceColor, Widget viewport, ValueListenable<double>? leadingScrollDistance)?
  edgeEffectBuilder;

  final GroupLink? contentGroup;

  final MorphTarget? sheetToViewTarget;
  final MotionStartup animationStartup;

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
  static final _transformTargets = Expando<MorphTarget>();

  static MorphTarget _transformTarget(MateoSurfaceTransformTarget target) =>
      _transformTargets[target] ??= MorphTarget(tag: target, duration: target.duration, curve: target.curve);

  final GroupLink _contentGroup = GroupLink();

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
    final contentGroup = widget.contentGroup ?? _contentGroup;
    final capturedContent = Group(
      link: contentGroup,
      child: _clipContent(withEdgeEffect(viewport)),
    );
    final presentation = Stack(
      fit: StackFit.passthrough,
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(child: _clipContent(ColoredBox(color: surfaceColor))),
        capturedContent,
      ],
    );
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
        child: presentation,
      ),
    );

    return _buildAnimation(surface: surface, color: surfaceColor, contentGroup: contentGroup);
  }

  Widget _buildAnimation({required Widget surface, required Color color, required GroupLink contentGroup}) {
    final animation = widget.animation;
    final child = animation is MateoSurfaceAnimationPop
        ? Motion.list(
            startup: widget.animationStartup,
            interactive: true,
            effects: [
              ScaleInMotionEffect(scale: animation.beginScale, duration: animation.duration, curve: animation.curve),
              FadeInMotionEffect(duration: animation.duration, curve: animation.curve),
            ],
            child: surface,
          )
        : surface;
    final transforms = <MorphTarget, MateoSurfaceAnimationTransform>{
      ?widget.sheetToViewTarget: kSheetToViewTransformAnimation,
      if (animation is MateoSurfaceAnimationTransform) _transformTarget(animation.target): animation,
    };
    if (transforms.isEmpty) return child;

    return Morph(
      targets: transforms.keys.toList(),
      canMatch: _canMatch,
      flightConfig: .custom(
        _SurfaceTransformAnimationFlightDelegate(
          color: color,
          shape: widget.shape,
          content: contentGroup,
          animations: transforms,
        ),
      ),
      child: child,
    );
  }

  bool _canMatch(MorphTarget target, MorphMatchContext match) {
    final automaticTarget = widget.sheetToViewTarget;
    if (automaticTarget == null || identical(target, automaticTarget)) return true;
    // A supplied transform cannot replace sheet/view motion, even when the
    // automatic endpoint cannot be captured.
    return !(automaticTarget.canMatch?.call(match) ?? false);
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
