part of '../base_mateo_surface.dart';

final class _SurfaceTransformAnimationFlightDelegate
    extends MorphFlightDelegate<_SurfaceTransformAnimationFlightFrame> {
  _SurfaceTransformAnimationFlightDelegate({
    required this.color,
    required this.shape,
    required this.content,
    required MateoSurfaceAnimationTransform animation,
  }) : _effects = _SurfaceTransformAnimationContentEffects(animation.contentEffects);

  final Color color;
  final MateoRoundedShapeBorder shape;
  final Widget content;
  final _SurfaceTransformAnimationContentEffects _effects;

  @override
  _SurfaceTransformAnimationFlightFrame properties(MorphEndpointContext endpoint) {
    return _SurfaceTransformAnimationFlightFrame.capture(endpoint, color: color, shape: shape, content: content);
  }

  @override
  _SurfaceTransformAnimationFlightFrame lerpProperties(
    _SurfaceTransformAnimationFlightFrame source,
    _SurfaceTransformAnimationFlightFrame destination,
    MorphFlightProgress progress,
  ) => _SurfaceTransformAnimationFlightFrame.lerp(
    source,
    destination,
    progress.curvedProgress,
    content: _effects.interpolate(source.content, destination.content, progress),
  );

  @override
  Widget buildFlight(BuildContext context, MorphFlight<_SurfaceTransformAnimationFlightFrame> flight) =>
      AnimatedBuilder(
        animation: flight.curvedAnimation,
        builder: (context, child) {
          final frame = flight.properties;
          final border = frame.borderFor(flight.bounds.size);

          return DecoratedBox(
            decoration: ShapeDecoration(color: frame.color, shape: border),
            child: ClipPath(
              clipper: ShapeBorderClipper(shape: border),
              child: Stack(
                children: [
                  for (final layer in frame.content.layers)
                    Positioned.fromRect(
                      rect: layer.bounds,
                      child: Opacity(
                        opacity: layer.opacity,
                        child: FittedBox(fit: .contain, child: layer.capture),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
}
