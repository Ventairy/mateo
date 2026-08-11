part of 'mateo_circular_loading_indicator.dart';

class _MateoCircularLoadingIndicatorPainter extends CustomPainter {
  _MateoCircularLoadingIndicatorPainter({
    required Color color,
    required Color trackColor,
    required Animation<double>? progress,
  }) : color = color,
       trackColor = trackColor,
       progress = progress,
       _trackPaint = Paint()
         ..color = trackColor
         ..style = PaintingStyle.stroke,
       _indicatorPaint = Paint()
         ..color = color
         ..strokeCap = StrokeCap.round
         ..style = PaintingStyle.stroke,
       super(repaint: progress);

  static const double _trackWidthFactor = 1 / 14;
  static const double _indicatorWidthFactor = 1 / 14;
  static const double _indicatorSweep = 100 * math.pi / 180;
  static const double _topCenterAngle = -math.pi / 2;
  static const double _completeRotation = math.pi * 2;

  final Color color;
  final Color trackColor;
  final Animation<double>? progress;
  final Paint _trackPaint;
  final Paint _indicatorPaint;
  Size? _paintSize;
  Offset _center = Offset.zero;
  var _radius = 0.0;
  Rect _indicatorBounds = Rect.zero;

  double get trackWidthFactor => _trackWidthFactor;
  double get indicatorWidthFactor => _indicatorWidthFactor;
  double get indicatorSweep => _indicatorSweep;
  double get startAngle =>
      _topCenterAngle -
      _indicatorSweep / 2 +
      (progress?.value ?? 0) * _completeRotation;

  @override
  void paint(Canvas canvas, Size size) {
    final diameter = size.shortestSide;
    if (diameter <= 0) return;

    _synchronizeGeometry(size, diameter);

    canvas
      ..drawCircle(_center, _radius, _trackPaint)
      ..drawArc(
        _indicatorBounds,
        startAngle,
        _indicatorSweep,
        false,
        _indicatorPaint,
      );
  }

  void _synchronizeGeometry(Size size, double diameter) {
    if (_paintSize == size) return;

    final trackWidth = diameter * _trackWidthFactor;
    _paintSize = size;
    _center = size.center(Offset.zero);
    _radius = (diameter - trackWidth) / 2;
    _indicatorBounds = Rect.fromCircle(center: _center, radius: _radius);
    _trackPaint.strokeWidth = trackWidth;
    _indicatorPaint.strokeWidth = diameter * _indicatorWidthFactor;
  }

  @override
  bool shouldRepaint(
    covariant _MateoCircularLoadingIndicatorPainter oldDelegate,
  ) {
    return oldDelegate.color != color ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progress != progress;
  }
}
