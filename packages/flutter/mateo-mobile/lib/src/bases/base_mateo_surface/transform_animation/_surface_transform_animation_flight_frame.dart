part of '../base_mateo_surface.dart';

@immutable
final class _SurfaceTransformAnimationFlightFrame {
  const _SurfaceTransformAnimationFlightFrame({
    required this.color,
    required this.shape,
    required this.shapeSize,
    required this.content,
    required this.effects,
  });

  factory _SurfaceTransformAnimationFlightFrame.capture(
    MorphEndpointContext endpoint, {
    required Color color,
    required MateoRoundedShapeBorder shape,
    required GroupLink content,
    required _SurfaceTransformAnimationContentEffects effects,
  }) {
    final localSize = endpoint.localSize;
    final overlaySize = endpoint.overlayBounds.size;
    final scaleX = overlaySize.width / localSize.width;
    final scaleY = overlaySize.height / localSize.height;
    final uniformScale = (scaleX - scaleY).abs() <= 1e-10 * scaleX.abs();
    // Uniform scaling can be represented by a native radius. Unequal axis
    // scales keep the local outline and transform it only when painting.
    return _SurfaceTransformAnimationFlightFrame(
      color: color,
      shape: .new(radius: shape.resolveRadius(localSize) * (uniformScale ? scaleX : 1)),
      shapeSize: uniformScale ? overlaySize : localSize,
      content: .capture(endpoint, content),
      effects: effects,
    );
  }

  factory _SurfaceTransformAnimationFlightFrame.lerp(
    _SurfaceTransformAnimationFlightFrame source,
    _SurfaceTransformAnimationFlightFrame destination,
    double progress, {
    required _SurfaceTransformAnimationFlightContent content,
  }) {
    final outline = MateoRoundedShapeBorder.lerp(
      begin: (radius: source.shape.resolveRadius(source.shapeSize), size: source.shapeSize),
      end: (radius: destination.shape.resolveRadius(destination.shapeSize), size: destination.shapeSize),
      progress: progress,
    );

    return _SurfaceTransformAnimationFlightFrame(
      color: Color.lerp(source.color, destination.color, progress)!,
      shape: outline.border,
      shapeSize: outline.size,
      content: content,
      effects: source.effects,
    );
  }

  final _SurfaceTransformAnimationContentEffects effects;
  final Color color;
  final MateoRoundedShapeBorder shape;
  final Size shapeSize;
  final _SurfaceTransformAnimationFlightContent content;

  ShapeBorder borderFor(Size bounds) {
    return bounds == shapeSize ? shape : _SurfaceTransformAnimationFlightScaledBorder(shape: shape, size: shapeSize);
  }
}
