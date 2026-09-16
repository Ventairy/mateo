part of '../base_mateo_surface.dart';

typedef _SurfaceTransformAnimationFlightLayerIdentity = ({Widget capture, Rect bounds});

@immutable
final class _SurfaceTransformAnimationFlightLayer {
  const _SurfaceTransformAnimationFlightLayer({required this.capture, required this.bounds, this.opacity = 1});

  final Widget capture;
  final Rect bounds;
  final double opacity;

  _SurfaceTransformAnimationFlightLayerIdentity get identity => (capture: capture, bounds: bounds);

  _SurfaceTransformAnimationFlightLayer copyWith({Rect? bounds, double? opacity}) {
    return _SurfaceTransformAnimationFlightLayer(
      capture: capture,
      bounds: bounds ?? this.bounds,
      opacity: opacity ?? this.opacity,
    );
  }

  _SurfaceTransformAnimationFlightLayer translate(Offset offset) => copyWith(bounds: bounds.shift(offset));

  _SurfaceTransformAnimationFlightLayer scale(double factor, Offset origin) => copyWith(
    bounds: Rect.fromCenter(
      center: origin + (bounds.center - origin) * factor,
      width: bounds.width * factor,
      height: bounds.height * factor,
    ),
  );

  _SurfaceTransformAnimationFlightLayer fade(double visibility) => copyWith(opacity: opacity * visibility);
}
