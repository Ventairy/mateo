part of '../base_mateo_transform.dart';

@immutable
final class _MateoTransformAnimationFlightContent {
  _MateoTransformAnimationFlightContent({
    required this.size,
    required Iterable<_MateoTransformAnimationFlightLayer> layers,
  }) : layers = List.unmodifiable(layers);

  factory _MateoTransformAnimationFlightContent.capture(
    MorphEndpointContext endpoint,
    Widget content,
  ) {
    final size = endpoint.overlayBounds.size;
    return _MateoTransformAnimationFlightContent(
      size: size,
      layers: [
        _MateoTransformAnimationFlightLayer(
          capture: SizedBox.fromSize(
            size: size,
            child: FittedBox(
              fit: .fill,
              child: endpoint.descendantWidget(content),
            ),
          ),
          bounds: Offset.zero & size,
        ),
      ],
    );
  }

  factory _MateoTransformAnimationFlightContent.combine(
    _MateoTransformAnimationFlightContent source,
    _MateoTransformAnimationFlightContent destination,
  ) {
    assert(
      source.size == destination.size,
      'Content layers must share a coordinate frame before combining.',
    );
    final layers = <_MateoTransformAnimationFlightLayerIdentity, _MateoTransformAnimationFlightLayer>{};
    for (final layer in source.layers.followedBy(destination.layers)) {
      if (layer.opacity == 0) continue;
      layers.update(
        layer.identity,
        (previous) => previous.copyWith(
          opacity: (previous.opacity + layer.opacity).clamp(0.0, 1.0),
        ),
        ifAbsent: () => layer,
      );
    }
    return _MateoTransformAnimationFlightContent(
      size: source.size,
      layers: layers.values,
    );
  }

  final Size size;
  final List<_MateoTransformAnimationFlightLayer> layers;

  _MateoTransformAnimationFlightContent centeredIn(Size bounds) {
    if (bounds == size) return this;
    final offset = Offset(
      (bounds.width - size.width) / 2,
      (bounds.height - size.height) / 2,
    );
    return _MateoTransformAnimationFlightContent(
      size: bounds,
      layers: layers.map((layer) => layer.translate(offset)),
    );
  }

  _MateoTransformAnimationFlightContent scale(double factor) {
    if (factor == 1) return this;
    return _MateoTransformAnimationFlightContent(
      size: size,
      layers: layers.map(
        (layer) => layer.scale(factor, size.center(Offset.zero)),
      ),
    );
  }

  _MateoTransformAnimationFlightContent fade(double visibility) {
    if (visibility == 1) return this;
    return _MateoTransformAnimationFlightContent(
      size: size,
      layers: layers.map((layer) => layer.fade(visibility)),
    );
  }
}
