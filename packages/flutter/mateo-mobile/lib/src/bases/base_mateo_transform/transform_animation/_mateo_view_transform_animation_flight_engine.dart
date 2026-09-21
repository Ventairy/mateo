part of '../base_mateo_transform.dart';

final class _MateoViewTransformAnimationFlightEngine {
  const _MateoViewTransformAnimationFlightEngine._();

  static _MateoViewTransformAnimationFlightFrame capture(
    MorphEndpointContext endpoint, {
    required Color color,
    required MateoRoundedShapeBorder shape,
    required Widget content,
    required _MateoTransformAnimationContentEffects effects,
  }) {
    final (:capturedShape, :shapeSize) = _MateoTransformAnimationFlightGeometry.captureShape(endpoint, shape);
    return _MateoViewTransformAnimationFlightFrame(
      color: color,
      shape: capturedShape,
      shapeSize: shapeSize,
      content: .capture(endpoint, content),
      effects: effects,
    );
  }

  static _MateoViewTransformAnimationFlightFrame lerp(
    _MateoViewTransformAnimationFlightFrame source,
    _MateoViewTransformAnimationFlightFrame destination,
    MorphFlightProgress progress,
  ) {
    final (:shape, :shapeSize) = _MateoTransformAnimationFlightGeometry.lerpShape(
      source,
      destination,
      progress.curvedProgress,
    );
    return _MateoViewTransformAnimationFlightFrame(
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

final class _MateoTransformAnimationFlightGeometry {
  const _MateoTransformAnimationFlightGeometry._();

  static ({MateoRoundedShapeBorder capturedShape, Size shapeSize}) captureShape(
    MorphEndpointContext endpoint,
    MateoRoundedShapeBorder shape,
  ) {
    final localSize = endpoint.localSize;
    final overlaySize = endpoint.overlayBounds.size;
    final scaleX = overlaySize.width / localSize.width;
    final scaleY = overlaySize.height / localSize.height;
    final uniformScale = (scaleX - scaleY).abs() <= 1e-10 * scaleX.abs();
    return (
      capturedShape: .new(
        radius: shape.resolveRadius(localSize) * (uniformScale ? scaleX : 1),
      ),
      shapeSize: uniformScale ? overlaySize : localSize,
    );
  }

  static ({MateoRoundedShapeBorder shape, Size shapeSize}) lerpShape(
    _MateoTransformAnimationFlightFrame source,
    _MateoTransformAnimationFlightFrame destination,
    double progress,
  ) {
    final outline = MateoRoundedShapeBorder.lerp(
      begin: (
        radius: source.shape.resolveRadius(source.shapeSize),
        size: source.shapeSize,
      ),
      end: (
        radius: destination.shape.resolveRadius(destination.shapeSize),
        size: destination.shapeSize,
      ),
      progress: progress,
    );
    return (shape: outline.border, shapeSize: outline.size);
  }
}
