part of '../mateo_surface.dart';

final class _MateoSurfaceEndpoint extends Container {
  _MateoSurfaceEndpoint({
    required this.flightChild,
    required this.surfaceColor,
    required this.resolveTopExtent,
    required this.resolveBottomExtent,
    required this.usesBoundaryMask,
    required BoxDecoration decoration,
    required Widget child,
  }) : super(
         decoration: decoration,
         clipBehavior: Clip.antiAlias,
         child: child,
       );

  final Widget flightChild;
  final Color surfaceColor;
  final double Function(Size size) resolveTopExtent;
  final double Function(Size size) resolveBottomExtent;
  final bool usesBoundaryMask;
}

@immutable
final class _MateoSurfaceFlightProperties {
  const _MateoSurfaceFlightProperties({
    required this.container,
    required this.surfaceColor,
    required this.topExtent,
    required this.bottomExtent,
    required this.usesBoundaryMask,
  });

  final MorphContainerProperties container;
  final Color surfaceColor;
  final double topExtent;
  final double bottomExtent;
  final bool usesBoundaryMask;
}

final class _MateoSurfaceFlightDelegate
    extends MorphFlightDelegate<_MateoSurfaceFlightProperties> {
  const _MateoSurfaceFlightDelegate();

  static const _containerDelegate = MorphContainerFlightDelegate(
    switchThreshold: 0.5,
  );

  @override
  _MateoSurfaceFlightProperties properties(MorphEndpointContext endpoint) {
    final surface = endpoint.child as _MateoSurfaceEndpoint;
    final decoration = surface.decoration! as BoxDecoration;
    final cleanContainer = Container(
      decoration: decoration,
      clipBehavior: surface.clipBehavior,
      child: surface.flightChild,
    );
    return _MateoSurfaceFlightProperties(
      container: MorphContainerFlightDelegate.captureContainer(
        context: endpoint.context,
        container: cleanContainer,
        size: endpoint.overlayBounds.size,
        axisScale: endpoint.axisScale,
        switchThreshold: 0.5,
      ),
      surfaceColor: surface.surfaceColor,
      topExtent:
          surface.resolveTopExtent(endpoint.localSize) * endpoint.axisScale.dy,
      bottomExtent:
          surface.resolveBottomExtent(endpoint.localSize) *
          endpoint.axisScale.dy,
      usesBoundaryMask: surface.usesBoundaryMask,
    );
  }

  @override
  _MateoSurfaceFlightProperties lerpProperties(
    _MateoSurfaceFlightProperties source,
    _MateoSurfaceFlightProperties destination,
    MorphFlightProgress progress,
  ) {
    return _MateoSurfaceFlightProperties(
      container: _containerDelegate.lerpProperties(
        source.container,
        destination.container,
        progress,
      ),
      surfaceColor: Color.lerp(
        source.surfaceColor,
        destination.surfaceColor,
        progress.curvedProgress,
      )!,
      topExtent: ui.lerpDouble(
        source.topExtent,
        destination.topExtent,
        progress.curvedProgress,
      )!,
      bottomExtent: ui.lerpDouble(
        source.bottomExtent,
        destination.bottomExtent,
        progress.curvedProgress,
      )!,
      usesBoundaryMask: source.usesBoundaryMask || destination.usesBoundaryMask,
    );
  }

  @override
  Widget buildFlight(
    BuildContext context,
    MorphFlight<_MateoSurfaceFlightProperties> flight,
  ) {
    return AnimatedBuilder(
      animation: flight.curvedAnimation,
      builder: (context, _) => _buildProperties(context, flight.properties),
    );
  }

  Widget _buildProperties(
    BuildContext context,
    _MateoSurfaceFlightProperties properties,
  ) {
    final container = properties.container;
    final childProperties = container.child;
    var child = childProperties == null
        ? null
        : MorphChildFlightDelegate.build(
            context,
            childProperties,
            switchTransition: _crossfade,
          );
    if (child != null &&
        (properties.topExtent > 0 || properties.bottomExtent > 0)) {
      child = properties.usesBoundaryMask
          ? _MateoSurfaceFlightBoundaryMask(
              topExtent: properties.topExtent,
              bottomExtent: properties.bottomExtent,
              child: child,
            )
          : Stack(
              fit: StackFit.passthrough,
              children: [
                child,
                Positioned.fill(
                  child: IgnorePointer(
                    child: ExcludeSemantics(
                      child: CustomPaint(
                        painter: _MateoSurfaceFlightBoundaryPainter(
                          color: properties.surfaceColor,
                          topExtent: properties.topExtent,
                          bottomExtent: properties.bottomExtent,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
    }
    return Container(
      alignment: container.alignment,
      padding: container.padding,
      decoration: container.decoration,
      foregroundDecoration: container.foregroundDecoration,
      clipBehavior: container.clipBehavior,
      child: child,
    );
  }

  static Widget _crossfade(Widget child, Animation<double> animation) {
    return FadeTransition(opacity: animation, child: child);
  }
}

final class _MateoSurfaceFlightBoundaryMask extends StatelessWidget {
  const _MateoSurfaceFlightBoundaryMask({
    required this.topExtent,
    required this.bottomExtent,
    required this.child,
  });

  final double topExtent;
  final double bottomExtent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var masked = child;
    for (final boundary in <(bool, double)>[
      (true, topExtent),
      (false, bottomExtent),
    ]) {
      final (top, extent) = boundary;
      if (extent <= 0) continue;
      masked = ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (bounds) =>
            _boundaryShader(bounds: bounds, top: top, extent: extent),
        child: masked,
      );
    }
    return masked;
  }

  Shader _boundaryShader({
    required Rect bounds,
    required bool top,
    required double extent,
  }) {
    final extentFraction = (extent / bounds.height).clamp(0.0, 1.0);
    final stops = <double>[if (!top) 0];
    final colors = <Color>[if (!top) Colors.white];
    final indices = top
        ? Iterable<int>.generate(33)
        : Iterable<int>.generate(33, (index) => 32 - index);
    for (final index in indices) {
      final progress = index / 32;
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
  }
}

final class _MateoSurfaceFlightBoundaryPainter extends CustomPainter {
  const _MateoSurfaceFlightBoundaryPainter({
    required this.color,
    required this.topExtent,
    required this.bottomExtent,
  });

  final Color color;
  final double topExtent;
  final double bottomExtent;

  @override
  void paint(Canvas canvas, Size size) {
    _paintBoundary(canvas, size, top: true, extent: topExtent);
    _paintBoundary(canvas, size, top: false, extent: bottomExtent);
  }

  void _paintBoundary(
    Canvas canvas,
    Size size, {
    required bool top,
    required double extent,
  }) {
    if (extent <= 0) return;
    final resolvedExtent = math.min(extent, size.height);
    final rect = Rect.fromLTWH(
      0,
      top ? 0 : size.height - resolvedExtent,
      size.width,
      resolvedExtent,
    );
    final stops = <double>[
      for (
        var index = 0;
        index <= MateoSurface._boundaryFadeSegmentCount;
        index++
      )
        index / MateoSurface._boundaryFadeSegmentCount,
    ];
    final colors = <Color>[
      for (
        var index = 0;
        index <= MateoSurface._boundaryFadeSegmentCount;
        index++
      )
        color.withValues(
          alpha:
              color.a *
              (1 -
                  MateoSurface._passingContentVisibility(
                    index / MateoSurface._boundaryFadeSegmentCount,
                  )),
        ),
    ];
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: top ? Alignment.topCenter : Alignment.bottomCenter,
          end: top ? Alignment.bottomCenter : Alignment.topCenter,
          stops: stops,
          colors: colors,
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_MateoSurfaceFlightBoundaryPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.topExtent != topExtent ||
        oldDelegate.bottomExtent != bottomExtent;
  }
}
