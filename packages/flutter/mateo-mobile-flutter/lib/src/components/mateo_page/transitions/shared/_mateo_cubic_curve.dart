part of '../../mateo_page.dart';

const _mateoPageEaseOutQuad = _MateoPageCubicCurve(0.25, 0.46, 0.45, 0.94);
const _mateoPageEaseInOutSine = _MateoPageCubicCurve(0.445, 0.05, 0.55, 0.95);
const _mateoPageEaseInOutCubic = _MateoPageCubicCurve(0.645, 0.045, 0.355, 1);

final class _MateoPageCubicCurve {
  const _MateoPageCubicCurve(double x1, double y1, double x2, double y2)
    : _cx = 3 * x1,
      _bx = 3 * (x2 - x1) - 3 * x1,
      _ax = 1 - 3 * x1 - (3 * (x2 - x1) - 3 * x1),
      _cy = 3 * y1,
      _by = 3 * (y2 - y1) - 3 * y1,
      _ay = 1 - 3 * y1 - (3 * (y2 - y1) - 3 * y1);

  final double _ax;
  final double _bx;
  final double _cx;
  final double _ay;
  final double _by;
  final double _cy;

  double transform(double value) {
    var parameter = value;
    final estimate = ((_ax * parameter + _bx) * parameter + _cx) * parameter;
    final error = estimate - value;
    final derivative = (3 * _ax * parameter + 2 * _bx) * parameter + _cx;
    final secondDerivative = 6 * _ax * parameter + 2 * _bx;

    // One Halley refinement stays within 0.00091 of the solved Mateo curves.
    parameter -= (2 * error * derivative) / (2 * derivative * derivative - error * secondDerivative);

    return ((_ay * parameter + _by) * parameter + _cy) * parameter;
  }
}
