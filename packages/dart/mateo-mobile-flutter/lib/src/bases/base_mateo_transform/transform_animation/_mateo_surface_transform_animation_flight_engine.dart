part of '../base_mateo_transform.dart';

final class _MateoSurfaceTransformAnimationFlightEngine {
  const _MateoSurfaceTransformAnimationFlightEngine._();

  static _MateoSurfaceTransformAnimationFlightFrame capture(
    MorphEndpointContext endpoint, {
    required Color color,
    required MateoRoundedShapeBorder shape,
    required Widget content,
    required _MateoTransformAnimationContentEffects effects,
  }) {
    final (:capturedShape, :shapeSize) = _MateoTransformAnimationFlightGeometry.captureShape(endpoint, shape);
    return _MateoSurfaceTransformAnimationFlightFrame(
      color: color,
      shape: capturedShape,
      shapeSize: shapeSize,
      content: .capture(endpoint, content),
      effects: effects,
    );
  }

  static _MateoSurfaceTransformAnimationFlightFrame lerp(
    _MateoSurfaceTransformAnimationFlightFrame source,
    _MateoSurfaceTransformAnimationFlightFrame destination,
    MorphFlightProgress progress,
  ) {
    final (:shape, :shapeSize) = _MateoTransformAnimationFlightGeometry.lerpShape(
      source,
      destination,
      progress.curvedProgress,
    );
    return _MateoSurfaceTransformAnimationFlightFrame(
      color: Color.lerp(
        source.color,
        destination.color,
        progress.curvedProgress,
      )!,
      shape: shape,
      shapeSize: shapeSize,
      content: source.effects.interpolate(
        source.content,
        destination.content,
        progress,
      ),
      effects: source.effects,
    );
  }
}
