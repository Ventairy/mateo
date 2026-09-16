part of 'mateo_loading_indicator.dart';

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
         ..style = .stroke,
       _indicatorPaint = Paint()
         ..color = color
         ..strokeCap = .round
         ..style = .stroke,
       super(repaint: progress);

  static const double _strokeWidthFactor = 0.14;
  static const double _indicatorSweep = 100 * math.pi / 180;
  static const double _topCenterAngle = -math.pi / 2;
  static const double _completeRotation = math.pi * 2;

  final Color color;
  final Color trackColor;
  final Animation<double>? progress;
  final Paint _trackPaint;
  final Paint _indicatorPaint;
  Size? _paintSize;
  Offset _center = .zero;
  var _radius = 0.0;
  Rect _indicatorBounds = .zero;

  double get trackWidthFactor => _strokeWidthFactor;
  double get indicatorWidthFactor => _strokeWidthFactor;
  double get indicatorSweep => _indicatorSweep;
  double get startAngle => _topCenterAngle - _indicatorSweep / 2 + (progress?.value ?? 0) * _completeRotation;

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

    final trackWidth = diameter * _strokeWidthFactor;
    _paintSize = size;
    _center = size.center(.zero);
    _radius = (diameter - trackWidth) / 2;
    _indicatorBounds = Rect.fromCircle(center: _center, radius: _radius);
    _trackPaint.strokeWidth = trackWidth;
    _indicatorPaint.strokeWidth = diameter * _strokeWidthFactor;
  }

  @override
  bool shouldRepaint(
    covariant _MateoCircularLoadingIndicatorPainter oldDelegate,
  ) {
    return oldDelegate.color != color || oldDelegate.trackColor != trackColor || oldDelegate.progress != progress;
  }
}
