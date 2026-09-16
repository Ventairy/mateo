part of 'mateo_loading_indicator.dart';

class _MateoDotsLoadingIndicatorPainter extends CustomPainter {
  _MateoDotsLoadingIndicatorPainter({
    required this.color,
    required this.dotCount,
    required this.dotRadius,
    required this.jumpHeight,
    required this.spacing,
    required Animation<double>? progress,
  }) : _progress = progress,
       animated = progress != null,
       _paint = (Paint()..color = color),
       super(repaint: progress);

  static const double _phaseGap = 0.18;
  static const double _phaseOffset = 0.06;

  final Color color;
  final int dotCount;
  final double dotRadius;
  final double jumpHeight;
  final double spacing;
  final bool animated;
  final Animation<double>? _progress;
  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    if (dotRadius <= 0 || size.width <= 0 || size.height <= 0) return;

    final diameter = dotRadius * 2;
    final centerY = jumpHeight + dotRadius;
    final progress = _progress?.value ?? 0;

    for (var index = 0; index < dotCount; index++) {
      final phase = (progress - index * _phaseGap + _phaseOffset) % 1;
      final lift = animated ? _liftFor(phase) : 0.0;
      final centerX = dotRadius + index * (diameter + spacing);

      canvas.drawCircle(
        Offset(centerX, centerY - jumpHeight * lift),
        dotRadius,
        _paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MateoDotsLoadingIndicatorPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.dotCount != dotCount ||
        oldDelegate.dotRadius != dotRadius ||
        oldDelegate.jumpHeight != jumpHeight ||
        oldDelegate.spacing != spacing ||
        oldDelegate._progress != _progress ||
        oldDelegate.animated != animated;
  }

  double _liftFor(double t) {
    return 0.5 - math.cos(t * math.pi * 2) * 0.5;
  }
}
