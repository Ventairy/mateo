part of 'mateo_toggle.dart';

class _MateoTogglePainter extends CustomPainter {
  _MateoTogglePainter({
    required this.position,
    required this.press,
    required this.colorScheme,
    required this.enabled,
    required this.animationsDisabled,
    required this.textDirection,
  }) : super(repaint: Listenable.merge([position, press]));

  static const double _trackWidth = 58;
  static const double _trackHeight = 30;
  static const double _circleDiameter = 24;
  static const double _circleInset = 3;
  static const double _pressedScale = 0.94;

  final Animation<double> position;
  final Animation<double> press;
  final MateoToggleColorScheme colorScheme;
  final bool enabled;
  final bool animationsDisabled;
  final TextDirection textDirection;
  final Paint _paint = Paint()..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Size size) {
    final positionValue = position.value.clamp(0.0, 1.0);
    final visualPosition = switch (textDirection) {
      TextDirection.ltr => positionValue,
      TextDirection.rtl => 1 - positionValue,
    };
    final trackBounds = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: _trackWidth,
      height: _trackHeight,
    );
    const trackRadius = Radius.circular(_trackHeight / 2);
    final track = RRect.fromRectAndRadius(trackBounds, trackRadius);
    final trackColor = enabled
        ? Color.lerp(
            colorScheme.trackOff,
            colorScheme.trackOn,
            positionValue,
          )!
        : colorScheme.trackDisabled;
    final circleColor = enabled
        ? Color.lerp(
            colorScheme.circleOff,
            colorScheme.circleOn,
            positionValue,
          )!
        : colorScheme.circleDisabled;

    canvas.drawRRect(track, _paint..color = trackColor);

    final pressScale = animationsDisabled ? 1.0 : 1 - ((1 - _pressedScale) * press.value.clamp(0.0, 1.0));
    final circleDiameter = _circleDiameter * pressScale;
    const circleTravel = _trackWidth - (_circleInset * 2) - _circleDiameter;
    final restingCenterX = trackBounds.left + _circleInset + (_circleDiameter / 2) + (circleTravel * visualPosition);
    final circleCenter = Offset(
      restingCenterX,
      trackBounds.center.dy,
    );
    final circleBounds = Rect.fromCenter(
      center: circleCenter,
      width: circleDiameter,
      height: circleDiameter,
    );
    final circle = RRect.fromRectAndRadius(
      circleBounds,
      Radius.circular(circleDiameter / 2),
    );

    canvas
      ..save()
      ..clipRRect(track)
      ..drawRRect(circle, _paint..color = circleColor)
      ..restore();
  }

  @override
  bool shouldRepaint(covariant _MateoTogglePainter oldDelegate) =>
      oldDelegate.position != position ||
      oldDelegate.press != press ||
      oldDelegate.colorScheme != colorScheme ||
      oldDelegate.enabled != enabled ||
      oldDelegate.animationsDisabled != animationsDisabled ||
      oldDelegate.textDirection != textDirection;
}
