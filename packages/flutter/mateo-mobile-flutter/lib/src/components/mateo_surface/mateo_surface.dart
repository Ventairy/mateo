part of '../mateo_surface.dart';

/// A reusable Mateo surface for content, depth, boundaries, and continuity.
///
/// A surface owns its background, clipping, elevation, optional boundary
/// effect, and optional animations. It sizes naturally in loose
/// constraints and expands when its parent supplies tight constraints.
///
/// Use [MateoSurface.scrollable] when Mateo should own one vertical viewport
/// around ordinary box content. Use [MateoSurface] when content is fixed or
/// owns its own scrolling.
///
/// See also:
///  * [MateoBoundaryEffect], the reusable foundation for passing content.
///  * [MateoSurfaceAnimation], the optional matched-geometry behavior.
class MateoSurface extends StatefulWidget {
  /// Creates a surface around fixed or app-managed content.
  ///
  /// [child] owns its internal layout. [color] defaults to Mateo's semantic
  /// background. [borderRadius] controls both the painted shape and automatic
  /// anti-aliased clipping. [elevation] accepts the complete Mateo elevation
  /// range from zero through two.
  const MateoSurface({
    required this.child,
    super.key,
    this.color,
    this.borderRadius = BorderRadius.zero,
    this.elevation = 0,
    this.boundaryEffect,
    this.animation,
  }) : keyboardViewportBehavior = MateoSurfaceKeyboardViewportBehavior.resize,
       _scrollable = false,
       assert(
         elevation >= 0 && elevation <= 2,
         'elevation must be between 0 and 2, inclusive.',
       );

  /// Creates a surface that owns vertical scrolling around box content.
  ///
  /// [child] is ordinary non-scrollable content, commonly a [Column]. Short
  /// content fills the usable viewport so [Spacer] and [Expanded] work;
  /// overflowing content scrolls with platform-primary behavior. The surface
  /// owns its specialized controller and does not expose it publicly.
  const MateoSurface.scrollable({
    required this.child,
    super.key,
    this.color,
    this.borderRadius = BorderRadius.zero,
    this.elevation = 0,
    this.boundaryEffect = const MateoBoundaryEffect.fade(),
    this.animation,
    this.keyboardViewportBehavior = MateoSurfaceKeyboardViewportBehavior.resize,
  }) : _scrollable = true,
       assert(
         elevation >= 0 && elevation <= 2,
         'elevation must be between 0 and 2, inclusive.',
       );

  static const double _fadeExtentFactor = 1 / 9;
  static const double _minimumFadeExtent = 64;
  static const double _maximumFadeExtent = 96;
  static const int _boundaryFadeSegmentCount = 32;

  static double _passingContentVisibility(double progress) {
    final progressSquared = progress * progress;
    final progressCubed = progressSquared * progress;
    final smootherStep = progressCubed * (progress * (progress * 6 - 15) + 10);
    final midpointDistance = smootherStep - 0.5;
    final interiorStrengthBias = 0.4 * smootherStep * (1 - smootherStep) * midpointDistance * midpointDistance;
    return smootherStep * (0.12 + 0.88 * smootherStep) - interiorStrengthBias;
  }

  /// Content painted inside the surface.
  final Widget child;

  /// Semantic background color of the surface.
  ///
  /// When omitted, this resolves from Mateo's semantic background.
  final Color? color;

  /// Shape used to paint and clip the surface.
  final BorderRadiusGeometry borderRadius;

  /// Mateo elevation from zero through two, inclusive.
  final double elevation;

  /// Optional effect protecting content at selected surface boundaries.
  final MateoBoundaryEffect? boundaryEffect;

  /// Optional semantic animation for this surface.
  final MateoSurfaceAnimation? animation;

  /// Policy used to size this surface's managed viewport around the keyboard.
  ///
  /// This value affects [MateoSurface.scrollable] only.
  final MateoSurfaceKeyboardViewportBehavior keyboardViewportBehavior;

  final bool _scrollable;

  @override
  State<MateoSurface> createState() => _MateoSurfaceState();
}

class _MateoSurfaceState extends State<MateoSurface> {
  final ValueNotifier<int> _boundaryRepaint = ValueNotifier(0);
  MorphTarget? _morphTarget;
  ScrollController? _standaloneController;
  ScrollMetrics? _scrollMetrics;

  ScrollController get _ownedStandaloneController => _standaloneController ??= _MateoSurfaceScrollController();

  @override
  void didUpdateWidget(MateoSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._scrollable && !widget._scrollable) {
      _standaloneController?.dispose();
      _standaloneController = null;
      _scrollMetrics = null;
    }
  }

  @override
  void dispose() {
    _standaloneController?.dispose();
    _boundaryRepaint.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;
    _scrollMetrics = notification.metrics;
    _boundaryRepaint.value += 1;
    return false;
  }

  bool _handleScrollMetricsNotification(
    ScrollMetricsNotification notification,
  ) {
    if (notification.metrics.axis != Axis.vertical) return false;
    _scrollMetrics = notification.metrics;
    _boundaryRepaint.value += 1;
    return false;
  }

  double _resolvedFadeExtent(
    double surfaceExtent,
    MateoBoundaryEffect effect,
  ) {
    if (!surfaceExtent.isFinite || surfaceExtent <= 0) return 0;
    final smallSurfaceDivisor = effect.top && effect.bottom ? 3 : 2;
    return math.min(
      (surfaceExtent * MateoSurface._fadeExtentFactor).clamp(
        MateoSurface._minimumFadeExtent,
        MateoSurface._maximumFadeExtent,
      ),
      surfaceExtent / smallSurfaceDivisor,
    );
  }

  Widget _buildBoundaryMask({
    required Widget child,
    required double height,
    required double topMaximumExtent,
    required double bottomMaximumExtent,
    required MateoBoundaryEffect effect,
    required Listenable repaint,
  }) {
    return AnimatedBuilder(
      animation: repaint,
      child: child,
      builder: (context, child) {
        final topExtent = effect.top
            ? _effectiveFadeExtent(
                _MateoSurfaceBoundaryPosition.top,
                topMaximumExtent,
              )
            : 0.0;
        final bottomExtent = effect.bottom
            ? _effectiveFadeExtent(
                _MateoSurfaceBoundaryPosition.bottom,
                bottomMaximumExtent,
              )
            : 0.0;
        if (topExtent <= 0 && bottomExtent <= 0) return child!;
        var masked = child!;
        for (final boundary in <(bool, double)>[
          (true, topExtent),
          (false, bottomExtent),
        ]) {
          final (top, extent) = boundary;
          if (extent <= 0) continue;
          final extentFraction = (extent / height).clamp(0.0, 1.0);
          masked = ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (bounds) {
              final stops = <double>[if (!top) 0];
              final colors = <Color>[if (!top) Colors.white];
              const segmentCount = MateoSurface._boundaryFadeSegmentCount;
              final indices = top
                  ? Iterable<int>.generate(segmentCount + 1)
                  : Iterable<int>.generate(segmentCount + 1, (index) => segmentCount - index);
              for (final index in indices) {
                final progress = index / segmentCount;
                stops.add(
                  top ? extentFraction * progress : 1 - extentFraction * progress,
                );
                colors.add(
                  Colors.white.withValues(
                    alpha: MateoSurface._passingContentVisibility(progress),
                  ),
                );
              }
              if (top) {
                stops.add(1);
                colors.add(Colors.white);
              }
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: stops,
                colors: colors,
              ).createShader(bounds);
            },
            child: masked,
          );
        }
        return masked;
      },
    );
  }

  Widget _buildStandaloneBoundaryMask({
    required Widget child,
    required MateoBoundaryEffect effect,
  }) {
    var masked = child;
    for (final top in [true, false]) {
      if (top ? !effect.top : !effect.bottom) continue;
      masked = ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (bounds) {
          final extentFraction = (_resolvedFadeExtent(bounds.height, effect) / bounds.height).clamp(0.0, 1.0);
          final stops = <double>[if (!top) 0];
          final colors = <Color>[if (!top) Colors.white];
          const segmentCount = MateoSurface._boundaryFadeSegmentCount;
          final indices = top
              ? Iterable<int>.generate(segmentCount + 1)
              : Iterable<int>.generate(segmentCount + 1, (index) => segmentCount - index);
          for (final index in indices) {
            final progress = index / segmentCount;
            stops.add(
              top ? extentFraction * progress : 1 - extentFraction * progress,
            );
            colors.add(
              Colors.white.withValues(
                alpha: MateoSurface._passingContentVisibility(progress),
              ),
            );
          }
          if (top) {
            stops.add(1);
            colors.add(Colors.white);
          }
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: stops,
            colors: colors,
          ).createShader(bounds);
        },
        child: masked,
      );
    }
    return masked;
  }

  Widget _decorateAndAnimate({
    required BuildContext context,
    required Widget child,
    required Widget flightChild,
    required Color color,
    required BorderRadius borderRadius,
    required double Function(Size size) resolveTopExtent,
    required double Function(Size size) resolveBottomExtent,
    required bool usesBoundaryMask,
  }) {
    final decoration = BoxDecoration(
      color: color,
      borderRadius: borderRadius,
      boxShadow: MateoElevation.toShadows(
        elevation: widget.elevation,
        palette: context.mateo.palette,
      ),
    );
    final animation = widget.animation;
    if (animation == null) {
      return Container(
        decoration: decoration,
        clipBehavior: Clip.antiAlias,
        child: child,
      );
    }
    assert(
      animation.target == null || animation.target!.tag == animation.id,
      'The surface target tag must equal its animation id.',
    );

    if (_morphTarget?.tag != animation.id) {
      _morphTarget = MorphTarget(tag: animation.id);
    }

    return Morph(
      target: animation.target ?? _morphTarget!,
      duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : animation.duration,
      curve: animation.curve,
      flightConfig: const .custom(_MateoSurfaceFlightDelegate()),
      watchDestination: true,
      child: _MateoSurfaceEndpoint(
        flightChild: flightChild,
        surfaceColor: color,
        resolveTopExtent: resolveTopExtent,
        resolveBottomExtent: resolveBottomExtent,
        usesBoundaryMask: usesBoundaryMask,
        decoration: decoration,
        child: child,
      ),
    );
  }

  Widget _buildStandaloneOrdinarySurface({
    required BuildContext context,
    required Color color,
    required BorderRadius borderRadius,
  }) {
    final effect = widget.boundaryEffect;
    var child = widget.child;
    if (effect != null) {
      if (color.a < 1) {
        child = _buildStandaloneBoundaryMask(
          child: child,
          effect: effect,
        );
      } else {
        child = Stack(
          fit: StackFit.passthrough,
          children: [
            child,
            Positioned.fill(
              child: _MateoSurfaceBoundaryOverlay(
                color: color,
                effect: effect,
                resolveExtent: _resolvedFadeExtent,
              ),
            ),
          ],
        );
      }
    }
    return _decorateAndAnimate(
      context: context,
      child: child,
      flightChild: widget.child,
      color: color,
      borderRadius: borderRadius,
      resolveTopExtent: (size) => effect?.top == true ? _resolvedFadeExtent(size.height, effect!) : 0,
      resolveBottomExtent: (size) => effect?.bottom == true ? _resolvedFadeExtent(size.height, effect!) : 0,
      usesBoundaryMask: effect != null && color.a < 1,
    );
  }

  double _effectiveFadeExtent(
    _MateoSurfaceBoundaryPosition position,
    double maximumExtent,
  ) {
    return _MateoSurfaceBoundaryScrollMetrics.resolve(
      metrics: _scrollMetrics,
      position: position,
      maximumExtent: maximumExtent,
      fallbackExtent: maximumExtent,
    );
  }

  Widget _buildBoundaryFade({
    required _MateoSurfaceBoundaryPosition position,
    required double maximumExtent,
    required Color color,
    required Listenable repaint,
  }) {
    return SizedBox(
      width: double.infinity,
      height: maximumExtent,
      child: _MateoSurfaceBoundaryReveal(
        key: ValueKey('mateo_surface_boundary_reveal_${position.name}'),
        repaint: repaint,
        position: position,
        maximumExtent: maximumExtent,
        resolveExtent: _effectiveFadeExtent,
        child: _MateoSurfaceBoundaryFade(
          key: ValueKey('mateo_surface_boundary_fade_${position.name}'),
          position: position,
          color: color,
          extent: maximumExtent,
        ),
      ),
    );
  }

  Widget _buildFixedContent(
    BuildContext context,
    MateoSurfaceLayoutConstraints geometry,
  ) {
    final paddingOverride = geometry.paddingOverride;
    final leading = geometry.reserveLeadingExtent ? geometry.leadingExtent : paddingOverride?.top ?? 0;
    final trailing = geometry.reserveTrailingExtent
        ? geometry.maxHeight - geometry.viewportExtent + geometry.trailingExtent
        : paddingOverride?.bottom ?? 0;
    var child = widget.child;
    if (paddingOverride != null) {
      child = MediaQuery(
        data: MediaQuery.of(context).removePadding(
          removeLeft: true,
          removeTop: true,
          removeRight: true,
          removeBottom: true,
        ),
        child: child,
      );
    }
    return Padding(
      padding: EdgeInsets.only(
        left: paddingOverride?.left ?? 0,
        top: leading,
        right: paddingOverride?.right ?? 0,
        bottom: trailing,
      ),
      child: child,
    );
  }

  Widget _buildScrollableContent({
    required BuildContext context,
    required BoxConstraints constraints,
    required ScrollController controller,
    MateoSurfaceLayoutConstraints? geometry,
  }) {
    if (!constraints.hasBoundedHeight) {
      throw FlutterError.fromParts([
        ErrorSummary('MateoSurface.scrollable requires bounded height.'),
        ErrorDescription(
          'A scrollable surface needs a finite vertical viewport from its parent.',
        ),
      ]);
    }
    final paddingOverride = geometry?.paddingOverride;
    var child = widget.child;
    if (paddingOverride != null && (paddingOverride.left > 0 || paddingOverride.right > 0)) {
      child = Padding(
        padding: EdgeInsets.only(
          left: paddingOverride.left,
          right: paddingOverride.right,
        ),
        child: child,
      );
    }
    final leading = geometry?.leadingExtent ?? 0;
    final trailing = geometry?.trailingExtent ?? 0;
    final viewportExtent = geometry?.viewportExtent ?? constraints.maxHeight;
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: constraints.maxWidth,
        height: viewportExtent,
        child: PrimaryScrollController(
          controller: controller,
          child: CustomScrollView(
            primary: true,
            physics: const _MateoSurfaceOverflowOnlyScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.only(top: leading),
                sliver: SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: trailing),
                    child: _MateoSurfaceFocusRevealObserver(
                      leadingExtent: leading,
                      trailingExtent: trailing,
                      child: MediaQuery(
                        data: MediaQuery.of(context)
                            .removePadding(
                              removeLeft: paddingOverride != null,
                              removeTop: true,
                              removeRight: paddingOverride != null,
                              removeBottom: true,
                            )
                            .removeViewInsets(removeBottom: true),
                        child: SafeArea(
                          top: false,
                          bottom: false,
                          left: paddingOverride == null,
                          right: paddingOverride == null,
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSurface({
    required BuildContext context,
    required BoxConstraints constraints,
    required Color color,
    required BorderRadius borderRadius,
    required ScrollController? controller,
    required MateoSurfaceLayoutConstraints? geometry,
  }) {
    final content = widget._scrollable
        ? _buildScrollableContent(
            context: context,
            constraints: constraints,
            controller: controller!,
            geometry: geometry,
          )
        : geometry == null
        ? widget.child
        : _buildFixedContent(context, geometry);
    final repaint = Listenable.merge([
      _boundaryRepaint,
      ?controller,
    ]);
    final effect = widget.boundaryEffect;
    final baseFadeExtent = effect == null ? 0.0 : _resolvedFadeExtent(constraints.maxHeight, effect);
    final topFadeExtent = geometry == null ? baseFadeExtent : geometry.leadingExtent + baseFadeExtent;
    final bottomOffset = geometry == null ? 0.0 : constraints.maxHeight - geometry.viewportExtent;
    final usesMask = effect != null && color.a < 1;
    final maskedContent = usesMask
        ? _buildBoundaryMask(
            child: content,
            height: constraints.maxHeight,
            topMaximumExtent: topFadeExtent,
            bottomMaximumExtent: baseFadeExtent,
            effect: effect,
            repaint: repaint,
          )
        : content;
    final contents = NotificationListener<ScrollMetricsNotification>(
      onNotification: _handleScrollMetricsNotification,
      child: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Stack(
          fit: constraints.isTight ? StackFit.expand : StackFit.passthrough,
          children: [
            maskedContent,
            if (!usesMask && effect?.top == true && topFadeExtent > 0)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildBoundaryFade(
                  position: _MateoSurfaceBoundaryPosition.top,
                  maximumExtent: topFadeExtent,
                  color: color,
                  repaint: repaint,
                ),
              ),
            if (!usesMask && effect?.bottom == true && baseFadeExtent > 0)
              Positioned(
                left: 0,
                right: 0,
                bottom: bottomOffset,
                child: _buildBoundaryFade(
                  position: _MateoSurfaceBoundaryPosition.bottom,
                  maximumExtent: baseFadeExtent,
                  color: color,
                  repaint: repaint,
                ),
              ),
          ],
        ),
      ),
    );
    return _decorateAndAnimate(
      context: context,
      child: contents,
      flightChild: content,
      color: color,
      borderRadius: borderRadius,
      resolveTopExtent: (_) =>
          effect?.top == true ? _effectiveFadeExtent(_MateoSurfaceBoundaryPosition.top, topFadeExtent) : 0,
      resolveBottomExtent: (_) =>
          effect?.bottom == true ? _effectiveFadeExtent(_MateoSurfaceBoundaryPosition.bottom, baseFadeExtent) : 0,
      usesBoundaryMask: usesMask,
    );
  }

  @override
  Widget build(BuildContext context) {
    final host = _MateoSurfaceHostScope.maybeOf(context);
    final isHosted = identical(host?.surface, widget);
    final color = widget.color ?? context.mateo.colorScheme.background;
    final borderRadius = widget.borderRadius.resolve(
      Directionality.of(context),
    );
    if (!widget._scrollable && !isHosted) {
      return _buildStandaloneOrdinarySurface(
        context: context,
        color: color,
        borderRadius: borderRadius,
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final geometry = constraints is MateoSurfaceLayoutConstraints ? constraints : null;
        final controller = widget._scrollable
            ? isHosted
                  ? host!.controller
                  : _ownedStandaloneController
            : null;
        return _buildSurface(
          context: context,
          constraints: constraints,
          color: color,
          borderRadius: borderRadius,
          controller: controller,
          geometry: geometry,
        );
      },
    );
  }
}
