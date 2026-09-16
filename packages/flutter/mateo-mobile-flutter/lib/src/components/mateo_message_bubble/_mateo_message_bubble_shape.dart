part of 'mateo_message_bubble.dart';

class _MateoMessageBubbleShape {
  const _MateoMessageBubbleShape._();

  static const double maximumBodyRadius = 32;
  static const double tailWidth = 17;
  static const double tailHeight = 15;
  static const double _maximumLobeRadius = 12;
  static const double _maximumDotRadius = 5;
  static const double _inverseSquareRootOfTwo = 0.7071067811865476;
  static const double _cosine15Degrees = 0.9659258262890683;
  static const double _sine15Degrees = 0.25881904510252074;
  static const double _arcControlScale = 0.3572655899081636;

  static Path bodyAndLobePathFor(
    Size size,
    MateoMessageDirection direction, [
    Path? reusablePath,
  ]) {
    final bodyWidth = size.width <= tailWidth ? size.width - size.width : size.width - tailWidth;
    final bodyHeight = size.height <= tailHeight ? size.height - size.height : size.height - tailHeight;
    final shortestBodyExtent = bodyWidth < bodyHeight ? bodyWidth : bodyHeight;
    final normalizedRadius = shortestBodyExtent / 2;
    final radius = normalizedRadius < maximumBodyRadius ? normalizedRadius : maximumBodyRadius;
    final lobeRadius = radius < _maximumLobeRadius ? radius : _maximumLobeRadius;
    final centerDistance = math.sqrt(
      math.max(0, radius * radius - lobeRadius * lobeRadius),
    );
    final cornerInset = radius - centerDistance * _inverseSquareRootOfTwo;
    final lobeX = bodyWidth - cornerInset;
    final lobeY = bodyHeight - cornerInset;
    final bridgeControl = (radius - (bodyWidth - lobeX)) * 0.45;
    final arcControl = _arcControlScale * lobeRadius;

    final arcStartX = lobeX + _cosine15Degrees * lobeRadius;
    final arcStartY = lobeY - _sine15Degrees * lobeRadius;
    final arcMiddleX = lobeX + _inverseSquareRootOfTwo * lobeRadius;
    final arcMiddleY = lobeY + _inverseSquareRootOfTwo * lobeRadius;
    final arcEndX = lobeX - _sine15Degrees * lobeRadius;
    final arcEndY = lobeY + _cosine15Degrees * lobeRadius;

    final mirror = direction == MateoMessageDirection.incoming;
    final xOrigin = mirror ? size.width : 0.0;
    final xScale = mirror ? -1.0 : 1.0;
    final path = (reusablePath ?? Path())
      ..reset()
      ..moveTo(xOrigin + xScale * radius, 0)
      ..lineTo(xOrigin + xScale * (bodyWidth - radius), 0)
      ..quadraticBezierTo(
        xOrigin + xScale * bodyWidth,
        0,
        xOrigin + xScale * bodyWidth,
        radius,
      )
      ..lineTo(
        xOrigin + xScale * bodyWidth,
        bodyHeight - radius,
      )
      ..cubicTo(
        xOrigin + xScale * bodyWidth,
        bodyHeight - radius + bridgeControl,
        xOrigin + xScale * (arcStartX - _sine15Degrees * bridgeControl),
        arcStartY - _cosine15Degrees * bridgeControl,
        xOrigin + xScale * arcStartX,
        arcStartY,
      )
      ..cubicTo(
        xOrigin + xScale * (arcStartX + _sine15Degrees * arcControl),
        arcStartY + _cosine15Degrees * arcControl,
        xOrigin + xScale * (arcMiddleX + _inverseSquareRootOfTwo * arcControl),
        arcMiddleY - _inverseSquareRootOfTwo * arcControl,
        xOrigin + xScale * arcMiddleX,
        arcMiddleY,
      )
      ..cubicTo(
        xOrigin + xScale * (arcMiddleX - _inverseSquareRootOfTwo * arcControl),
        arcMiddleY + _inverseSquareRootOfTwo * arcControl,
        xOrigin + xScale * (arcEndX + _cosine15Degrees * arcControl),
        arcEndY + _sine15Degrees * arcControl,
        xOrigin + xScale * arcEndX,
        arcEndY,
      )
      ..cubicTo(
        xOrigin + xScale * (arcEndX - _cosine15Degrees * bridgeControl),
        arcEndY - _sine15Degrees * bridgeControl,
        xOrigin + xScale * (bodyWidth - radius + bridgeControl),
        bodyHeight,
        xOrigin + xScale * (bodyWidth - radius),
        bodyHeight,
      )
      ..lineTo(xOrigin + xScale * radius, bodyHeight)
      ..quadraticBezierTo(
        xOrigin,
        bodyHeight,
        xOrigin,
        bodyHeight - radius,
      )
      ..lineTo(xOrigin, radius)
      ..quadraticBezierTo(xOrigin, 0, xOrigin + xScale * radius, 0)
      ..close();
    return path;
  }

  static RRect contentClipFor(Size size, MateoMessageDirection direction) {
    final double bodyWidth = math.max(0, size.width - tailWidth);
    final double bodyHeight = math.max(0, size.height - tailHeight);
    final shortestBodyExtent = bodyWidth < bodyHeight ? bodyWidth : bodyHeight;
    final radius = math.min(maximumBodyRadius, shortestBodyExtent / 2);
    final body = Rect.fromLTWH(
      direction == MateoMessageDirection.incoming ? size.width - bodyWidth : 0,
      0,
      bodyWidth,
      bodyHeight,
    );
    return RRect.fromRectAndRadius(body, Radius.circular(radius));
  }

  static double dotRadiusFor(Size size) {
    final shortestExtent = size.width < size.height ? size.width : size.height;
    final normalizedRadius = shortestExtent / 2;
    return normalizedRadius < _maximumDotRadius ? normalizedRadius : _maximumDotRadius;
  }

  static Offset dotCenterFor(
    Size size,
    MateoMessageDirection direction,
    double radius,
  ) {
    final horizontalInset = math.min(radius + 1, size.width - radius);
    final verticalInset = math.min(radius + 1, size.height - radius);
    return Offset(
      direction == MateoMessageDirection.incoming ? horizontalInset : size.width - horizontalInset,
      size.height - verticalInset,
    );
  }
}
