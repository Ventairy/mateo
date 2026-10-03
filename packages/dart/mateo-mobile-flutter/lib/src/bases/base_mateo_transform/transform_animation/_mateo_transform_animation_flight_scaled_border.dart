part of '../base_mateo_transform.dart';

final class _MateoTransformAnimationFlightScaledBorder extends ShapeBorder {
  const _MateoTransformAnimationFlightScaledBorder({
    required this.shape,
    required this.size,
  });

  final ShapeBorder shape;
  final Size size;

  @override
  EdgeInsetsGeometry get dimensions => .zero;

  @override
  ShapeBorder scale(double t) => this;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => shape
      .getOuterPath(Offset.zero & size, textDirection: textDirection)
      .transform(
        (Matrix4.identity()
              ..translateByDouble(rect.left, rect.top, 0, 1)
              ..scaleByDouble(
                rect.width / size.width,
                rect.height / size.height,
                1,
                1,
              ))
            .storage,
      );

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => getOuterPath(rect, textDirection: textDirection);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}
}
