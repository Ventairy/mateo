library;

import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui' hide Image;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mateo_mobile/src/theme/mateo_color_scheme/mateo_color_scheme.dart';
import 'package:mateo_mobile/src/theme/mateo_theme_data.dart';

part '_mateo_skeleton_canvas.dart';
part '_mateo_skeleton_leaf_registry.dart';
part '_mateo_skeleton_painting_context.dart';
part '_mateo_skeleton_render_object.dart';
part '_mateo_skeleton_render_object_widget.dart';
part 'effects/mateo_skeleton_effect.dart';
part 'effects/mateo_skeleton_fade_effect.dart';
part 'effects/mateo_skeleton_shimmer_effect.dart';
part 'mateo_skeleton_style.dart';

/// A Mateo Mobile skeleton widget that transforms its child tree into gray bone boxes
/// for loading-placeholder display.
///
/// Wraps any widget subtree and intercepts its painting at the canvas level,
/// replacing leaf draw calls (text, images, icons) with pill-shaped skeleton
/// bones.  Container widgets (cards, backgrounds) pass through unchanged so
/// the layout structure remains visible.
///
/// ## Performance
///
/// Rendering is driven at the render-object level — the effect animation
/// calls `markNeedsPaint` directly on the render object without any
/// `setState` or widget rebuilds.  When [MateoSkeletonStyle.effect] is `null`, no
/// [AnimationController] is created and the skeleton is rendered as a static
/// solid fill, adding zero per-frame cost.  Animated effects also fall back
/// to the static path when [MediaQueryData.disableAnimations] is `true`.
///
/// ## Usage
///
/// ```dart
/// // Simple wrap — static bones, zero per-frame cost.
/// MateoSkeleton(child: myCardWidget);
///
/// // Animated shimmer sweep.
/// MateoSkeleton(style: MateoSkeletonStyle(effect: MateoSkeletonShimmerEffect()), child: myCardWidget);
///
/// // Fade breathing pulse.
/// MateoSkeleton(style: MateoSkeletonStyle(effect: MateoSkeletonFadeEffect()), child: myCardWidget);
///
/// // Via the `.skeleton()` widget extension:
/// myCardWidget.skeleton();
/// myCardWidget.skeleton(style: MateoSkeletonStyle(effect: MateoSkeletonShimmerEffect()));
/// ```
///
/// See also:
///  * [MateoSkeletonStaticEffectBase], the base class for static skeleton effects.
///  * [MateoSkeletonAnimatedEffectBase], the base class for animated skeleton effects.
///  * [MateoSkeletonShimmerEffect], the built-in animated shimmer sweep effect.
///  * [MateoSkeletonFadeEffect], the built-in fade/breathing effect.
///  * [MateoSkeletonStyle], the style bundle for customizing skeleton appearance.
///  * `WidgetExtension` (`.skeleton()`), the widget extension that wraps any
///    widget with [MateoSkeleton].
class MateoSkeleton extends StatefulWidget {
  /// Creates a Mateo Mobile skeleton loading placeholder.
  const MateoSkeleton({
    required this.child,
    super.key,
    this.enabled = true,
    this.style,
  });

  /// The widget subtree to skeletonize when [enabled] is `true`.
  final Widget child;

  /// Whether the skeleton effect is active.
  ///
  /// When `false`, the [child] renders normally with zero skeleton overhead.
  final bool enabled;

  /// The visual style applied to the skeleton bones.
  ///
  /// When `null`, defaults to a [MateoSkeletonStyle] with all-null fields:
  /// theme-driven resting color, static solid fill (no effect), and pill
  /// text-line bones.  Pass a [MateoSkeletonStyle] to customize any subset
  final MateoSkeletonStyle? style;

  @override
  State<MateoSkeleton> createState() => _MateoSkeletonState();
}

class _MateoSkeletonState extends State<MateoSkeleton>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  bool _disableAnimations = false;

  MateoSkeletonStyle get _style => widget.style ?? const MateoSkeletonStyle();
  MateoSkeletonEffect? get _effect => _style.effect;

  bool get _shouldAnimate =>
      widget.enabled &&
      _effect is MateoSkeletonAnimatedEffectBase &&
      !_disableAnimations;

  bool get _effectActive {
    if (_effect == null) return false;
    if (_effect is MateoSkeletonAnimatedEffectBase && _disableAnimations) {
      return false;
    }
    return true;
  }

  void _syncAnimationController() {
    if (_shouldAnimate) {
      final effect = _effect! as MateoSkeletonAnimatedEffectBase;
      _controller ??= AnimationController(
        vsync: this,
        duration: effect.duration,
        lowerBound: effect.lowerBound,
        upperBound: effect.upperBound,
      );
      unawaited(_controller!.repeat());
    } else {
      _controller?.dispose();
      _controller = null;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _disableAnimations = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    _syncAnimationController();
  }

  @override
  void didUpdateWidget(MateoSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    final effectChanged = !_effectEquals(oldWidget.style?.effect, _effect);
    final enabledChanged = widget.enabled != oldWidget.enabled;
    if (effectChanged || enabledChanged) {
      _syncAnimationController();
    }
  }

  bool _effectEquals(MateoSkeletonEffect? a, MateoSkeletonEffect? b) {
    if (identical(a, b)) return true;
    return a == b;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    final colorScheme = Theme.of(
      context,
    ).extension<MateoThemeData>()!.colorScheme;
    final boneColor = _style.color ?? colorScheme.skeleton.bone;

    final effectiveStyle = _effectActive
        ? _style
        : MateoSkeletonStyle(
            color: _style.color,
            effect: null,
            textRadius: _style.textRadius,
          );

    return _MateoSkeletonRenderObjectWidget(
      colorScheme: colorScheme,
      style: effectiveStyle,
      boneColor: boneColor,
      effectAnimation: _shouldAnimate ? _controller : null,
      child: widget.child,
    );
  }
}
