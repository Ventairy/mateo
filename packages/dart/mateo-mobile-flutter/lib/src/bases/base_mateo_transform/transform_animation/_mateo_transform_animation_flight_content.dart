part of '../base_mateo_transform.dart';

@immutable
final class _MateoTransformAnimationFlightContent {
  _MateoTransformAnimationFlightContent({
    required this.size,
    required this.alignment,
    required Iterable<_MateoTransformAnimationFlightLayer> layers,
  }) : layers = List.unmodifiable(layers);

  factory _MateoTransformAnimationFlightContent.capture(
    MorphEndpointContext endpoint,
    Widget content, {
    Alignment alignment = Alignment.center,
  }) {
    final size = endpoint.overlayBounds.size;
    return _MateoTransformAnimationFlightContent(
      size: size,
      alignment: alignment,
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
    assert(source.alignment == destination.alignment, 'Content layers must share an anchor before combining.');
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
      alignment: source.alignment,
      layers: layers.values,
    );
  }

  final Size size;
  final Alignment alignment;
  final List<_MateoTransformAnimationFlightLayer> layers;

  _MateoTransformAnimationFlightContent alignedIn(Size bounds) {
    if (bounds == size) return this;
    final offset = alignment.alongOffset(Offset(bounds.width - size.width, bounds.height - size.height));
    return _MateoTransformAnimationFlightContent(
      size: bounds,
      alignment: alignment,
      layers: layers.map((layer) => layer.translate(offset)),
    );
  }

  _MateoTransformAnimationFlightContent scale(double factor) {
    if (factor == 1) return this;
    return _MateoTransformAnimationFlightContent(
      size: size,
      alignment: alignment,
      layers: layers.map(
        (layer) => layer.scale(factor, alignment.alongSize(size)),
      ),
    );
  }

  _MateoTransformAnimationFlightContent fade(double visibility) {
    if (visibility == 1) return this;
    return _MateoTransformAnimationFlightContent(
      size: size,
      alignment: alignment,
      layers: layers.map((layer) => layer.fade(visibility)),
    );
  }
}
