part of '../base_mateo_transform.dart';

final class _MateoTransformAnimationFlightDelegate extends MorphFlightDelegate<_MateoTransformAnimationFlightFrame> {
  _MateoTransformAnimationFlightDelegate({
    required this.color,
    required this.content,
    required List<BaseMateoTransformCandidate> candidates,
  }) : _candidates = {
         for (final candidate in candidates) candidate.target: candidate,
       };

  final Color color;
  final Widget content;
  final Map<MorphTarget, BaseMateoTransformCandidate> _candidates;

  @override
  _MateoTransformAnimationFlightFrame properties(
    MorphEndpointContext endpoint,
  ) {
    final candidate = _candidates[endpoint.target]!;
    return switch (candidate._engine) {
      .surface => _MateoSurfaceTransformAnimationFlightEngine.capture(
        endpoint,
        color: color,
        shape: candidate.shape,
        content: content,
        effects: candidate._contentEffects,
      ),
      .view => _MateoViewTransformAnimationFlightEngine.capture(
        endpoint,
        color: color,
        shape: candidate.shape,
        content: content,
        effects: candidate._contentEffects,
      ),
    };
  }

  @override
  _MateoTransformAnimationFlightFrame lerpProperties(
    _MateoTransformAnimationFlightFrame source,
    _MateoTransformAnimationFlightFrame destination,
    MorphFlightProgress progress,
  ) => switch ((source, destination)) {
    (
      final _MateoSurfaceTransformAnimationFlightFrame source,
      final _MateoSurfaceTransformAnimationFlightFrame destination,
    ) =>
      _MateoSurfaceTransformAnimationFlightEngine.lerp(
        source,
        destination,
        progress,
      ),
    (
      final _MateoViewTransformAnimationFlightFrame source,
      final _MateoViewTransformAnimationFlightFrame destination,
    ) =>
      _MateoViewTransformAnimationFlightEngine.lerp(
        source,
        destination,
        progress,
      ),
    _ => throw StateError('Mateo transform endpoints selected incompatible flights.'),
  };

  @override
  Widget buildFlight(
    BuildContext context,
    MorphFlight<_MateoTransformAnimationFlightFrame> flight,
  ) => AnimatedBuilder(
    animation: flight.curvedAnimation,
    builder: (context, child) {
      final frame = flight.properties;
      final border = frame.borderFor(flight.bounds.size);
      final content = Stack(
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
      );
      return ClipPath(
        clipper: ShapeBorderClipper(shape: border),
        child: ColoredBox(color: frame.color, child: content),
      );
    },
  );
}
