part of '../base_mateo_surface.dart';

final class _SurfaceTransformAnimationFlightDelegate
    extends MorphFlightDelegate<_SurfaceTransformAnimationFlightFrame> {
  _SurfaceTransformAnimationFlightDelegate({
    required this.color,
    required MateoRoundedShapeBorder shape,
    required this.content,
    required Map<MorphTarget, MateoSurfaceAnimationTransform> animations,
  }) : _transforms = animations.map(
         (target, animation) => MapEntry(
           target,
           (
             shape: animation.shape?.border ?? shape,
             effects: _SurfaceTransformAnimationContentEffects(animation.contentEffects),
           ),
         ),
       );

  final Color color;
  final GroupLink content;
  final Map<MorphTarget, ({MateoRoundedShapeBorder shape, _SurfaceTransformAnimationContentEffects effects})>
  _transforms;

  @override
  Iterable<GroupLink> get contentGroups => [content];

  @override
  _SurfaceTransformAnimationFlightFrame properties(MorphEndpointContext endpoint) {
    final transform = _transforms[endpoint.target]!;
    return _SurfaceTransformAnimationFlightFrame.capture(
      endpoint,
      color: color,
      shape: transform.shape,
      content: content,
      effects: transform.effects,
    );
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
    content: source.effects.interpolate(source.content, destination.content, progress),
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
