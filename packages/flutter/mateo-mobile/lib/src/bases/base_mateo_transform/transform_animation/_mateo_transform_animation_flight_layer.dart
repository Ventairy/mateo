part of '../base_mateo_transform.dart';

typedef _MateoTransformAnimationFlightLayerIdentity = ({
  Widget capture,
  Rect bounds,
});

@immutable
final class _MateoTransformAnimationFlightLayer {
  const _MateoTransformAnimationFlightLayer({
    required this.capture,
    required this.bounds,
    this.opacity = 1,
  });

  final Widget capture;
  final Rect bounds;
  final double opacity;

  _MateoTransformAnimationFlightLayerIdentity get identity => (capture: capture, bounds: bounds);

  _MateoTransformAnimationFlightLayer copyWith({
    Rect? bounds,
    double? opacity,
  }) => _MateoTransformAnimationFlightLayer(
    capture: capture,
    bounds: bounds ?? this.bounds,
    opacity: opacity ?? this.opacity,
  );

  _MateoTransformAnimationFlightLayer translate(Offset offset) => copyWith(bounds: bounds.shift(offset));

  _MateoTransformAnimationFlightLayer scale(double factor, Offset origin) => copyWith(
    bounds: Rect.fromCenter(
      center: origin + (bounds.center - origin) * factor,
      width: bounds.width * factor,
      height: bounds.height * factor,
    ),
  );

  _MateoTransformAnimationFlightLayer fade(double visibility) => copyWith(opacity: opacity * visibility);
}
