import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

import '../../foundation/mateo_elevation.dart';
import '../../foundation/mateo_rounded_convex_interpolation/mateo_rounded_convex_interpolation.dart';
import '../../theme/mateo_theme.dart';

part '_base_mateo_surface_content_layout.dart';
part '_base_mateo_surface_flight_delegate.dart';
part '_base_mateo_surface_scaled_border.dart';
part '_base_mateo_surface_scroll.dart';
part '_base_mateo_surface_scroll_controller.dart';
part '_base_mateo_surface_scroll_position.dart';
part '_render_base_mateo_surface_content_layout.dart';

@internal
class BaseMateoSurface extends StatefulWidget {
  const BaseMateoSurface({
    required this.child,
    this.transformId,
    this.color,
    this.elevation,
    this.shape = const RoundedRectangleBorder(),
    this.width,
    this.height,
    this.padding,
    this.alignment,
    this.obstructionInsets,
    this.obstructionInsetsChanges,
    this.edgeEffectBuilder,
    super.key,
  }) : _scrollable = false;

  const BaseMateoSurface.scrollable({
    required this.child,
    this.transformId,
    this.color,
    this.elevation,
    this.shape = const RoundedRectangleBorder(),
    this.width,
    this.height,
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

  final Object? transformId;

  final Color? color;

  final MateoElevation? elevation;

  final ShapeBorder shape;

  final double? width;

  final double? height;

  final EdgeInsetsGeometry? padding;

  final AlignmentGeometry? alignment;

  @override
  State<BaseMateoSurface> createState() => _BaseMateoSurfaceState();
}

class _BaseMateoSurfaceState extends State<BaseMateoSurface> {
  static const _transformDuration = Duration(milliseconds: 230);
  static const Cubic _transformCurve = Curves.easeInOutCubic;

  // Keep the complete resting surface mounted when animation is toggled.
  final GlobalKey _surfaceKey = GlobalKey();
  MorphTarget? _transformTarget;

  // Preserve viewport state when an effect wrapper is added or replaced.
  final GlobalKey _viewportKey = GlobalKey();

  _BaseMateoSurfaceScrollController? _scrollController;

  void _updateTransformTarget() {
    final id = widget.transformId;
    // Separate surface IDs from tags used directly by other Morph consumers.
    _transformTarget = id == null ? null : MorphTarget(tag: (_BaseMateoSurfaceState, id));
  }

  @override
  void initState() {
    super.initState();
    _updateTransformTarget();
  }

  @override
  void didUpdateWidget(BaseMateoSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.transformId != widget.transformId) _updateTransformTarget();
  }

  Widget _clipContent(Widget child) {
    if (widget.shape == const RoundedRectangleBorder()) {
      return ClipRect(child: child);
    }

    return ClipPath(
      clipper: ShapeBorderClipper(shape: widget.shape, textDirection: Directionality.maybeOf(context)),
      child: child,
    );
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._scrollable) _scrollController ??= _BaseMateoSurfaceScrollController();
    assert(
      widget.width == null || (widget.width! >= 0 && widget.width! < double.infinity),
      'width must be finite and nonnegative.',
    );
    assert(
      widget.height == null || (widget.height! >= 0 && widget.height! < double.infinity),
      'height must be finite and nonnegative.',
    );
    assert(widget.padding?.isNonNegative ?? true, 'padding must be nonnegative.');
    final content = _BaseMateoSurfaceContentLayout(
      obstructionInsets: widget.obstructionInsets,
      obstructionInsetsChanges: widget.obstructionInsetsChanges,
      padding: widget.padding?.resolve(Directionality.maybeOf(context)) ?? EdgeInsets.zero,
      alignment: widget.alignment?.resolve(Directionality.maybeOf(context)),
      child: widget.child,
    );
    final viewport = KeyedSubtree(
      key: _viewportKey,
      child: widget._scrollable ? _BaseMateoSurfaceScroll(controller: _scrollController!, child: content) : content,
    );
    final surfaceColor = widget.color ?? MateoTheme.of(context).colorScheme.background;
    final surface = SizedBox(
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
    final target = _transformTarget;
    if (target == null) return surface;
    return Morph(
      target: target,
      duration: _transformDuration,
      curve: _transformCurve,
      flightConfig: .custom(_BaseMateoSurfaceFlightDelegate(color: surfaceColor, shape: widget.shape)),
      child: surface,
    );
  }
}
