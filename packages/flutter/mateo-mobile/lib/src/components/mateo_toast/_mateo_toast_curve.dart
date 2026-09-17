part of 'mateo_toast_host.dart';

class _MateoToastCurve extends Curve {
  const _MateoToastCurve();

  static const double _frequency = 2 * math.pi;
  static const _tailStart = 0.6;
  static const double _tailDuration = 1 - _tailStart;
  static final double _decay = math.exp(-_frequency * _tailStart);
  static final double _position = 1 - (1 + _frequency * _tailStart) * _decay;
  static final double _velocity = _frequency * _frequency * _tailStart * _decay * _tailDuration;
  static final double _halfAcceleration =
      _frequency * _frequency * (1 - _frequency * _tailStart) * _decay * _tailDuration * _tailDuration / 2;
  static final double _remaining = 1 - _position;
  static final double _cubic = 10 * _remaining - 6 * _velocity - 3 * _halfAcceleration;
  static final double _quartic = -15 * _remaining + 8 * _velocity + 3 * _halfAcceleration;
  static final double _quintic = 6 * _remaining - 3 * _velocity - _halfAcceleration;

  @override
  double transformInternal(double t) {
    if (t <= _tailStart) return 1 - (1 + _frequency * t) * math.exp(-_frequency * t);
    final u = (t - _tailStart) / _tailDuration;
    return _position + u * (_velocity + u * (_halfAcceleration + u * (_cubic + u * (_quartic + u * _quintic))));
  }
}
