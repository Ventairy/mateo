part of '../base_mateo_transform.dart';

@immutable
sealed class _MateoTransformAnimationFlightFrame {
  const _MateoTransformAnimationFlightFrame({
    required this.color,
    required this.shape,
    required this.shapeSize,
    required this.content,
    required this.effects,
  });

  final _MateoTransformAnimationContentEffects effects;
  final Color color;
  final MateoRoundedShapeBorder shape;
  final Size shapeSize;
  final _MateoTransformAnimationFlightContent content;

  ShapeBorder borderFor(Size bounds) => bounds == shapeSize
      ? shape
      : _MateoTransformAnimationFlightScaledBorder(
          shape: shape,
          size: shapeSize,
        );
}

final class _MateoSurfaceTransformAnimationFlightFrame extends _MateoTransformAnimationFlightFrame {
  const _MateoSurfaceTransformAnimationFlightFrame({
    required super.color,
    required super.shape,
    required super.shapeSize,
    required super.content,
    required super.effects,
  });
}

final class _MateoViewTransformAnimationFlightFrame extends _MateoTransformAnimationFlightFrame {
  const _MateoViewTransformAnimationFlightFrame({
    required super.color,
    required super.shape,
    required super.shapeSize,
    required super.content,
    required super.effects,
  });
}
