part of '../base_mateo_surface.dart';

@immutable
final class _SurfaceTransformAnimationFlightContent {
  _SurfaceTransformAnimationFlightContent({
    required this.size,
    required Iterable<_SurfaceTransformAnimationFlightLayer> layers,
  }) : layers = List.unmodifiable(layers);

  factory _SurfaceTransformAnimationFlightContent.capture(MorphEndpointContext endpoint, GroupLink content) {
    final size = endpoint.overlayBounds.size;
    return _SurfaceTransformAnimationFlightContent(
      size: size,
      layers: [
        _SurfaceTransformAnimationFlightLayer(
          capture: SizedBox.fromSize(
            size: size,
            child: FittedBox(fit: .fill, child: endpoint.groupSnapshot(content)),
          ),
          bounds: Offset.zero & size,
        ),
      ],
    );
  }

  factory _SurfaceTransformAnimationFlightContent.combine(
    _SurfaceTransformAnimationFlightContent source,
    _SurfaceTransformAnimationFlightContent destination,
  ) {
    assert(source.size == destination.size, 'Content layers must share a coordinate frame before combining.');
    final layers = <_SurfaceTransformAnimationFlightLayerIdentity, _SurfaceTransformAnimationFlightLayer>{};
    for (final layer in source.layers.followedBy(destination.layers)) {
      if (layer.opacity == 0) continue;
      layers.update(
        layer.identity,
        (previous) => previous.copyWith(opacity: (previous.opacity + layer.opacity).clamp(0.0, 1.0)),
        ifAbsent: () => layer,
      );
    }
    return _SurfaceTransformAnimationFlightContent(size: source.size, layers: layers.values);
  }

  // The coordinate frame shared by all layers, independent of their scale.
  final Size size;
  final List<_SurfaceTransformAnimationFlightLayer> layers;

  _SurfaceTransformAnimationFlightContent centeredIn(Size bounds) {
    if (bounds == size) return this;
    final offset = Offset((bounds.width - size.width) / 2, (bounds.height - size.height) / 2);
    return _SurfaceTransformAnimationFlightContent(
      size: bounds,
      layers: layers.map((layer) => layer.translate(offset)),
    );
  }

  _SurfaceTransformAnimationFlightContent scale(double factor) {
    if (factor == 1) return this;
    return _SurfaceTransformAnimationFlightContent(
      size: size,
      layers: layers.map((layer) => layer.scale(factor, size.center(Offset.zero))),
    );
  }

  _SurfaceTransformAnimationFlightContent fade(double visibility) {
    if (visibility == 1) return this;
    return _SurfaceTransformAnimationFlightContent(size: size, layers: layers.map((layer) => layer.fade(visibility)));
  }
}
